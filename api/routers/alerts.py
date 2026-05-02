from fastapi import APIRouter
from pydantic import BaseModel
from datetime import datetime, timezone
from db.redis import get_redis_client
import json
import uuid

router = APIRouter(prefix="/alerts", tags=["Alerts"])

class AlertCreate(BaseModel):
    node_id: str
    severity: str
    message: str

@router.post("/publish")
async def publish_alert(payload: AlertCreate):
    redis_client = get_redis_client()

    alert = {
        "alert_id": str(uuid.uuid4()),
        "node_id": payload.node_id,
        "severity": payload.severity,
        "message": payload.message,
        "created_at": datetime.now(timezone.utc).isoformat(),
    }

    await redis_client.lpush("active_alerts", json.dumps(alert))
    await redis_client.ltrim("active_alerts", 0, 99)
    await redis_client.publish("fault_alerts", json.dumps(alert))

    return {"status": "published", "alert": alert}

@router.get("/active")
async def get_active_alerts():
    redis_client = get_redis_client()

    raw_alerts = await redis_client.lrange("active_alerts", 0, 99)
    alerts = [json.loads(a) for a in raw_alerts]

    return {
        "count": len(alerts),
        "alerts": alerts
    }
