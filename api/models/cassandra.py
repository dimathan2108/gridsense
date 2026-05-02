from pydantic import BaseModel
from datetime import datetime
from typing import List, Optional

class SensorSummary(BaseModel):
    sensor_id: str
    latest_reading_time: Optional[datetime] = None
    latest_value: Optional[float] = None
    metric_type: Optional[str] = None
    unit: Optional[str] = None
    one_hour_count: int = 0
    one_hour_avg: Optional[float] = None
    cached: bool = False

class SensorReading(BaseModel):
    sensor_id: str
    reading_time: datetime
    metric_type: str
    value: float
    unit: str
    quality_flag: int = 0

class SensorReadingBatch(BaseModel):
    readings: List[SensorReading]
