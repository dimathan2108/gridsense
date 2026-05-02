from pydantic import BaseModel
from typing import List

class AffectedNode(BaseModel):
    node_id: str
    node_type: str
    name: str | None = None
    depth: int

class FaultImpactResponse(BaseModel):
    origin_id: str
    affected_nodes: List[AffectedNode]
    total_affected: int
