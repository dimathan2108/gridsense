from pydantic import BaseModel
from typing import List
from typing import Any, Dict, Optional

class AffectedNode(BaseModel):
    node_id: str
    node_type: str
    name: str | None = None
    depth: int

class FaultImpactResponse(BaseModel):
    origin_id: str
    affected_nodes: List[AffectedNode]
    total_affected: int
    

class GraphNodeCreate(BaseModel):
    node_type: str
    node_id: str
    properties: Dict[str, Any] = {}

class GraphRelationshipCreate(BaseModel):
    from_id: str
    to_id: str
    relationship_type: str
    properties: Dict[str, Any] = {}

class RestorePathResponse(BaseModel):
    node_id: str
    alternative_paths: list[list[str]]
    total_paths: int
