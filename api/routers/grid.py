from fastapi import APIRouter, HTTPException
from db.neo4j import get_driver
from models.graph import AffectedNode, FaultImpactResponse
from models.graph import GraphNodeCreate, GraphRelationshipCreate, RestorePathResponse

router = APIRouter(prefix="/grid", tags=["Grid Topology"])

async def _node_exists(driver, node_id: str) -> bool:
    cypher = """
    MATCH (n)
    WHERE n.substation_id = $node_id
       OR n.asset_id = $node_id
       OR n.meter_id = $node_id
       OR n.feeder_id = $node_id
       OR n.gsp_id = $node_id
    RETURN count(n) > 0 AS exists
    """
    async with driver.session(database="neo4j") as session:
        result = await session.run(cypher, node_id=node_id)
        record = await result.single()
        return bool(record["exists"]) if record else False

@router.get("/fault-impact/{node_id}", response_model=FaultImpactResponse)
async def get_fault_impact(node_id: str, max_depth: int = 6):
    if max_depth > 10:
        raise HTTPException(
            status_code=400,
            detail="max_depth cannot exceed 10 to protect query performance"
        )

    cypher = f"""
    MATCH (origin)
    WHERE origin.substation_id = $node_id
       OR origin.asset_id = $node_id
       OR origin.meter_id = $node_id
       OR origin.feeder_id = $node_id
       OR origin.gsp_id = $node_id
    MATCH path = (origin)-[:FEEDS|SUPPLIES|CONNECTS_TO*1..{max_depth}]->(downstream)
    RETURN labels(downstream)[0] AS node_type,
           coalesce(
             downstream.substation_id,
             downstream.asset_id,
             downstream.meter_id,
             downstream.feeder_id,
             downstream.gsp_id
           ) AS node_id,
           downstream.name AS name,
           length(path) AS depth
    ORDER BY depth, node_id
    """

    driver = get_driver()

    async with driver.session(database="neo4j") as session:
        result = await session.run(cypher, node_id=node_id)
        records = await result.data()

    if not records and not await _node_exists(driver, node_id):
        raise HTTPException(
            status_code=404,
            detail=f"Node '{node_id}' not found in topology graph"
        )

    affected = [AffectedNode(**record) for record in records]

    return FaultImpactResponse(
        origin_id=node_id,
        affected_nodes=affected,
        total_affected=len(affected)
    )
    
@router.get("/restore-paths/{node_id}", response_model=RestorePathResponse)
async def get_restore_paths(node_id: str, max_depth: int = 6):
    if max_depth > 10:
        raise HTTPException(status_code=400, detail="max_depth cannot exceed 10")

    cypher = f"""
    MATCH (target)
    WHERE target.substation_id = $node_id
       OR target.asset_id = $node_id
       OR target.meter_id = $node_id
       OR target.feeder_id = $node_id
       OR target.gsp_id = $node_id
    MATCH path = (source:GridSupplyPoint)-[:FEEDS|SUPPLIES|CONNECTS_TO*1..{max_depth}]->(target)
    RETURN [n IN nodes(path) |
      coalesce(n.gsp_id, n.substation_id, n.feeder_id, n.asset_id, n.meter_id)
    ] AS path_ids
    LIMIT 10
    """

    driver = get_driver()
    async with driver.session(database="neo4j") as session:
        result = await session.run(cypher, node_id=node_id)
        records = await result.data()

    paths = [r["path_ids"] for r in records]

    if not paths and not await _node_exists(driver, node_id):
        raise HTTPException(status_code=404, detail=f"Node '{node_id}' not found")

    return RestorePathResponse(
        node_id=node_id,
        alternative_paths=paths,
        total_paths=len(paths)
    )


@router.post("/nodes")
async def create_graph_node(payload: GraphNodeCreate):
    allowed = {
        "Substation": "substation_id",
        "Transformer": "asset_id",
        "SmartMeter": "meter_id",
        "Feeder": "feeder_id",
        "GridSupplyPoint": "gsp_id",
    }

    if payload.node_type not in allowed:
        raise HTTPException(status_code=400, detail="Unsupported node_type")

    id_field = allowed[payload.node_type]
    props = dict(payload.properties)
    props[id_field] = payload.node_id

    cypher = f"""
    MERGE (n:{payload.node_type} {{{id_field}: $node_id}})
    SET n += $props
    RETURN n
    """

    driver = get_driver()
    async with driver.session(database="neo4j") as session:
        await session.run(cypher, node_id=payload.node_id, props=props)

    return {"status": "created_or_updated", "node_type": payload.node_type, "node_id": payload.node_id}


@router.post("/relationships")
async def create_graph_relationship(payload: GraphRelationshipCreate):
    allowed_relationships = {"FEEDS", "SUPPLIES", "CONNECTS_TO"}

    if payload.relationship_type not in allowed_relationships:
        raise HTTPException(status_code=400, detail="Unsupported relationship_type")

    cypher = f"""
    MATCH (a), (b)
    WHERE coalesce(a.gsp_id, a.substation_id, a.feeder_id, a.asset_id, a.meter_id) = $from_id
      AND coalesce(b.gsp_id, b.substation_id, b.feeder_id, b.asset_id, b.meter_id) = $to_id
    MERGE (a)-[r:{payload.relationship_type}]->(b)
    SET r += $props
    RETURN count(r) AS created
    """

    driver = get_driver()
    async with driver.session(database="neo4j") as session:
        result = await session.run(
            cypher,
            from_id=payload.from_id,
            to_id=payload.to_id,
            props=payload.properties,
        )
        record = await result.single()

    if not record or record["created"] == 0:
        raise HTTPException(status_code=404, detail="Source or target node not found")

    return {
        "status": "created_or_updated",
        "from_id": payload.from_id,
        "to_id": payload.to_id,
        "relationship_type": payload.relationship_type,
    }
