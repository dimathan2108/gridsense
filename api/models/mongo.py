from pydantic import BaseModel, Field
from typing import Any, Dict, Optional

class EquipmentCreate(BaseModel):
    asset_id: str
    equipment_type: str
    manufacturer: Optional[str] = None
    model: Optional[str] = None
    metadata: Dict[str, Any] = Field(default_factory=dict)

class EquipmentUpdate(BaseModel):
    equipment_type: Optional[str] = None
    manufacturer: Optional[str] = None
    model: Optional[str] = None
    metadata: Optional[Dict[str, Any]] = None
