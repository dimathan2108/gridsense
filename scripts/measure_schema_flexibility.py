import os
import csv
import json
import time
import asyncio
import statistics
from pathlib import Path

import asyncpg
from motor.motor_asyncio import AsyncIOMotorClient


def load_env(path=".env"):
    if not os.path.exists(path):
        return
    with open(path) as f:
        for line in f:
            line = line.strip()
            if not line or line.startswith("#") or "=" not in line:
                continue
            key, value = line.split("=", 1)
            os.environ.setdefault(key, value.strip().strip('"').strip("'"))


load_env()

OUTPUT_FILE = Path("measurements/mongo_vs_postgres_jsonb.csv")

MONGO_DB = os.getenv("MONGO_DATABASE", "gridsense")
MONGO_USER = os.getenv("MONGO_USERNAME")
MONGO_PASSWORD = os.getenv("MONGO_PASSWORD")
MONGO_URI = f"mongodb://{MONGO_USER}:{MONGO_PASSWORD}@127.0.0.1:27017/{MONGO_DB}?authSource=admin"

POSTGRES_HOST = "127.0.0.1"
POSTGRES_PORT = 5433
POSTGRES_USER = os.getenv("POSTGRES_USER")
POSTGRES_PASSWORD = os.getenv("POSTGRES_PASSWORD")
POSTGRES_DB = os.getenv("POSTGRES_DB")

RUNS = 10


def build_equipment_records():
    docs = []

    for i in range(1, 11):
        docs.append({
            "asset_id": f"TX_FLEX_{i:03d}",
            "type": "Transformer",
            "manufacturer": "ABB",
            "metadata": {
                "rating_kva": 400 + i,
                "cooling": "oil",
                "tap_positions": 5
            }
        })

    for i in range(1, 11):
        docs.append({
            "asset_id": f"SM_FLEX_{i:03d}",
            "type": "SmartMeter",
            "manufacturer": "Landis+Gyr",
            "metadata": {
                "firmware_version": f"3.{i}.0" if i <= 5 else f"2.{i}.0",
                "rated_voltage": 220 + i * 3,
                "communication": "4G"
            }
        })

    for i in range(1, 11):
        docs.append({
            "asset_id": f"FD_FLEX_{i:03d}",
            "type": "Feeder",
            "manufacturer": "GenericCableCo",
            "metadata": {
                "length_km": round(1.5 + i * 0.2, 2),
                "installation_type": "underground" if i % 2 == 0 else "overhead"
            }
        })

    return docs


async def seed_mongo(docs):
    client = AsyncIOMotorClient(MONGO_URI)
    db = client[MONGO_DB]
    collection = db.equipment_flex

    await collection.create_index("asset_id", unique=True)

    for doc in docs:
        await collection.update_one(
            {"asset_id": doc["asset_id"]},
            {"$set": doc},
            upsert=True
        )

    client.close()


async def seed_postgres(docs):
    conn = await asyncpg.connect(
        host=POSTGRES_HOST,
        port=POSTGRES_PORT,
        user=POSTGRES_USER,
        password=POSTGRES_PASSWORD,
        database=POSTGRES_DB,
    )

    await conn.execute("""
    CREATE TABLE IF NOT EXISTS equipment_jsonb (
        asset_id TEXT PRIMARY KEY,
        type TEXT NOT NULL,
        manufacturer TEXT,
        metadata JSONB NOT NULL
    )
    """)

    for doc in docs:
        await conn.execute("""
        INSERT INTO equipment_jsonb (asset_id, type, manufacturer, metadata)
        VALUES ($1, $2, $3, $4::jsonb)
        ON CONFLICT (asset_id)
        DO UPDATE SET
            type = EXCLUDED.type,
            manufacturer = EXCLUDED.manufacturer,
            metadata = EXCLUDED.metadata
        """, doc["asset_id"], doc["type"], doc["manufacturer"], json.dumps(doc["metadata"]))

    await conn.close()


async def measure_mongo():
    client = AsyncIOMotorClient(MONGO_URI)
    db = client[MONGO_DB]
    collection = db.equipment_flex

    queries = {
        "firmware_version_starts_3": lambda: collection.find({
            "metadata.firmware_version": {"$regex": "^3\\."}
        }).to_list(length=None),

        "smartmeter_rated_voltage_gt_230": lambda: collection.find({
            "type": "SmartMeter",
            "metadata.rated_voltage": {"$gt": 230}
        }).to_list(length=None),

        "count_by_type": lambda: collection.aggregate([
            {"$group": {"_id": "$type", "count": {"$sum": 1}}}
        ]).to_list(length=None),
    }

    rows = []

    for query_name, query_func in queries.items():
        latencies = []

        for _ in range(RUNS):
            start = time.perf_counter()
            result = await query_func()
            latency_ms = (time.perf_counter() - start) * 1000
            latencies.append(latency_ms)

        rows.append({
            "database": "MongoDB",
            "query": query_name,
            "runs": RUNS,
            "mean_latency_ms": round(statistics.mean(latencies), 4),
            "p50_latency_ms": round(statistics.median(latencies), 4),
            "result_count_last_run": len(result),
        })

    client.close()
    return rows


async def measure_postgres():
    conn = await asyncpg.connect(
        host=POSTGRES_HOST,
        port=POSTGRES_PORT,
        user=POSTGRES_USER,
        password=POSTGRES_PASSWORD,
        database=POSTGRES_DB,
    )

    queries = {
        "firmware_version_starts_3": """
            SELECT *
            FROM equipment_jsonb
            WHERE metadata ? 'firmware_version'
              AND metadata->>'firmware_version' LIKE '3.%'
        """,

        "smartmeter_rated_voltage_gt_230": """
            SELECT *
            FROM equipment_jsonb
            WHERE type = 'SmartMeter'
              AND (metadata->>'rated_voltage')::numeric > 230
        """,

        "count_by_type": """
            SELECT type, COUNT(*)
            FROM equipment_jsonb
            GROUP BY type
        """,
    }

    rows = []

    for query_name, sql in queries.items():
        latencies = []

        for _ in range(RUNS):
            start = time.perf_counter()
            result = await conn.fetch(sql)
            latency_ms = (time.perf_counter() - start) * 1000
            latencies.append(latency_ms)

        rows.append({
            "database": "PostgreSQL JSONB",
            "query": query_name,
            "runs": RUNS,
            "mean_latency_ms": round(statistics.mean(latencies), 4),
            "p50_latency_ms": round(statistics.median(latencies), 4),
            "result_count_last_run": len(result),
        })

    await conn.close()
    return rows


def save_csv(rows):
    OUTPUT_FILE.parent.mkdir(parents=True, exist_ok=True)

    with OUTPUT_FILE.open("w", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=rows[0].keys())
        writer.writeheader()
        writer.writerows(rows)


async def main():

    docs = build_equipment_records()

    print("Seeding MongoDB and PostgreSQL with same 30 records...")
    await seed_mongo(docs)
    await seed_postgres(docs)

    print("Measuring MongoDB queries...")
    mongo_rows = await measure_mongo()

    print("Measuring PostgreSQL JSONB queries...")
    postgres_rows = await measure_postgres()

    rows = mongo_rows + postgres_rows
    save_csv(rows)

    print(f"Saved results to {OUTPUT_FILE}")
    for row in rows:
        print(row)


if __name__ == "__main__":
    asyncio.run(main())
