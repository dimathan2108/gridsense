from fastapi import APIRouter, Query
from typing import List, Optional
import json
from datetime import datetime, timedelta, timezone
from db.redis import get_redis_client
from db.cassandra import get_cassandra_session
from models.cassandra import SensorReading, SensorReadingBatch, SensorSummary

router = APIRouter(prefix="/sensors", tags=["Sensors"])

@router.post("/readings")
def ingest_readings(batch: SensorReadingBatch):
    session = get_cassandra_session()

    insert_sensor = """
    INSERT INTO sensor_readings (
        sensor_id, reading_time, metric_type, value, unit, quality_flag
    ) VALUES (%s, %s, %s, %s, %s, %s)
    """

    insert_dashboard = """
    INSERT INTO sensor_readings_by_time (
        time_window_start, reading_time, sensor_id, metric_type, value, unit, quality_flag
    ) VALUES (%s, %s, %s, %s, %s, %s, %s)
    """

    for r in batch.readings:
        session.execute(insert_sensor, (
            r.sensor_id, r.reading_time, r.metric_type, r.value, r.unit, r.quality_flag
        ))

        bucket = r.reading_time.replace(second=0, microsecond=0)
        session.execute(insert_dashboard, (
            bucket, r.reading_time, r.sensor_id, r.metric_type, r.value, r.unit, r.quality_flag
        ))

    return {"inserted": len(batch.readings)}

@router.get("/{sensor_id}/readings", response_model=List[SensorReading])
def get_sensor_readings(
    sensor_id: str,
    limit: int = Query(10, ge=1, le=500),
    from_time: Optional[datetime] = None
):
    session = get_cassandra_session()

    if from_time:
        query = """
        SELECT sensor_id, reading_time, metric_type, value, unit, quality_flag
        FROM sensor_readings
        WHERE sensor_id = %s AND reading_time >= %s
        LIMIT %s
        """
        rows = session.execute(query, (sensor_id, from_time, limit))
    else:
        query = """
        SELECT sensor_id, reading_time, metric_type, value, unit, quality_flag
        FROM sensor_readings
        WHERE sensor_id = %s
        LIMIT %s
        """
        rows = session.execute(query, (sensor_id, limit))

    return [SensorReading(**row._asdict()) for row in rows]

@router.get("/{sensor_id}/summary", response_model=SensorSummary)
async def get_sensor_summary(sensor_id: str):
    redis_client = get_redis_client()
    cache_key = f"sensor_summary:{sensor_id}"

    cached = await redis_client.get(cache_key)
    if cached:
        data = json.loads(cached)
        data["cached"] = True
        return SensorSummary(**data)

    session = get_cassandra_session()

    latest_query = """
    SELECT sensor_id, reading_time, metric_type, value, unit
    FROM sensor_readings
    WHERE sensor_id = %s
    LIMIT 1
    """

    latest = session.execute(latest_query, (sensor_id,)).one()

    if latest is None:
        summary = SensorSummary(sensor_id=sensor_id)
    else:
        one_hour_ago = latest.reading_time - timedelta(hours=1)

        readings_query = """
        SELECT value
        FROM sensor_readings
        WHERE sensor_id = %s AND reading_time >= %s
        """

        rows = list(session.execute(readings_query, (sensor_id, one_hour_ago)))
        values = [r.value for r in rows]

        summary = SensorSummary(
            sensor_id=sensor_id,
            latest_reading_time=latest.reading_time,
            latest_value=latest.value,
            metric_type=latest.metric_type,
            unit=latest.unit,
            one_hour_count=len(values),
            one_hour_avg=sum(values) / len(values) if values else None,
            cached=False,
        )

    await redis_client.setex(
        cache_key,
        30,
        summary.model_dump_json()
    )

    return summary
