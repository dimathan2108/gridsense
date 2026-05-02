from fastapi import APIRouter, HTTPException
from db.neo4j import get_driver
from models.graph import AffectedNode, FaultImpactResponse

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
