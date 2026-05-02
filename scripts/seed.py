import os
import random
from datetime import datetime, timedelta

import asyncpg
from cassandra.cluster import Cluster
from motor.motor_asyncio import AsyncIOMotorClient
from neo4j import GraphDatabase
import asyncio


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

CASSANDRA_HOST = "127.0.0.1"
CASSANDRA_KEYSPACE = "gridsense"

NEO4J_URI = "bolt://127.0.0.1:7687"
NEO4J_USER = os.getenv("NEO4J_USER", "neo4j")
NEO4J_PASSWORD = os.getenv("NEO4J_PASSWORD")

MONGO_USER = os.getenv("MONGO_USERNAME")
MONGO_PASSWORD = os.getenv("MONGO_PASSWORD")
MONGO_DB = os.getenv("MONGO_DATABASE", "gridsense")
MONGO_URI = f"mongodb://{MONGO_USER}:{MONGO_PASSWORD}@127.0.0.1:27017/{MONGO_DB}?authSource=admin"

POSTGRES_HOST = "127.0.0.1"
POSTGRES_PORT = 5433
POSTGRES_USER = os.getenv("POSTGRES_USER")
POSTGRES_PASSWORD = os.getenv("POSTGRES_PASSWORD")
POSTGRES_DB = os.getenv("POSTGRES_DB")


def seed_neo4j():
    print("Seeding Neo4j...")

    driver = GraphDatabase.driver(
        NEO4J_URI,
        auth=(NEO4J_USER, NEO4J_PASSWORD)
    )

    with driver.session(database="neo4j") as session:
        session.run("CREATE CONSTRAINT gsp_id IF NOT EXISTS FOR (g:GridSupplyPoint) REQUIRE g.gsp_id IS UNIQUE")
        session.run("CREATE CONSTRAINT substation_id IF NOT EXISTS FOR (s:Substation) REQUIRE s.substation_id IS UNIQUE")
        session.run("CREATE CONSTRAINT feeder_id IF NOT EXISTS FOR (f:Feeder) REQUIRE f.feeder_id IS UNIQUE")
        session.run("CREATE CONSTRAINT transformer_id IF NOT EXISTS FOR (t:Transformer) REQUIRE t.asset_id IS UNIQUE")
        session.run("CREATE CONSTRAINT meter_id IF NOT EXISTS FOR (m:SmartMeter) REQUIRE m.meter_id IS UNIQUE")

        session.run("""
        MERGE (g:GridSupplyPoint {gsp_id: 'GSP_NORTH'})
        SET g.name = 'Northern Grid Supply Point',
            g.voltage_kv = 132,
            g.region = 'North Metro'
        """)

        for s in range(1, 11):
            substation_id = f"SS_{s:03d}"
            feeder_id = f"F_{s:03d}"

            session.run("""
            MERGE (s:Substation {substation_id: $substation_id})
            SET s.name = $name,
                s.voltage_kv = 11,
                s.region = $region
            """, substation_id=substation_id, name=f"Substation {s}", region=f"Region {((s - 1) % 3) + 1}")

            session.run("""
            MERGE (f:Feeder {feeder_id: $feeder_id})
            SET f.name = $name,
                f.status = 'active'
            """, feeder_id=feeder_id, name=f"Feeder {s}")

            session.run("""
            MATCH (g:GridSupplyPoint {gsp_id: 'GSP_NORTH'})
            MATCH (s:Substation {substation_id: $substation_id})
            MERGE (g)-[:FEEDS {voltage_kv: 132}]->(s)
            """, substation_id=substation_id)

            session.run("""
            MATCH (s:Substation {substation_id: $substation_id})
            MATCH (f:Feeder {feeder_id: $feeder_id})
            MERGE (s)-[:SUPPLIES {capacity_kva: 2000}]->(f)
            """, substation_id=substation_id, feeder_id=feeder_id)

            for t in range(1, 5):
                transformer_num = (s - 1) * 4 + t
                asset_id = f"TX_{transformer_num:03d}"

                session.run("""
                MERGE (t:Transformer {asset_id: $asset_id})
                SET t.name = $name,
                    t.rating_kva = $rating_kva,
                    t.status = 'normal',
                    t.manufacturer = $manufacturer
                """, asset_id=asset_id,
                     name=f"Transformer {transformer_num}",
                     rating_kva=250 + (transformer_num % 4) * 150,
                     manufacturer=["ABB", "Siemens", "Schneider", "GE"][transformer_num % 4])

                session.run("""
                MATCH (f:Feeder {feeder_id: $feeder_id})
                MATCH (t:Transformer {asset_id: $asset_id})
                MERGE (f)-[:CONNECTS_TO {distance_m: $distance_m}]->(t)
                """, feeder_id=feeder_id, asset_id=asset_id, distance_m=200 + transformer_num * 5)

                for m in range(1, 6):
                    meter_num = (transformer_num - 1) * 5 + m
                    meter_id = f"SM_{meter_num:05d}"
                    premise_id = f"PREM_{meter_num:05d}"

                    session.run("""
                    MERGE (m:SmartMeter {meter_id: $meter_id})
                    SET m.premise_id = $premise_id,
                        m.tariff_class = $tariff_class
                    """, meter_id=meter_id,
                         premise_id=premise_id,
                         tariff_class="commercial" if meter_num % 5 == 0 else "residential")

                    session.run("""
                    MATCH (t:Transformer {asset_id: $asset_id})
                    MATCH (m:SmartMeter {meter_id: $meter_id})
                    MERGE (t)-[:CONNECTS_TO]->(m)
                    """, asset_id=asset_id, meter_id=meter_id)

    driver.close()
    print("Neo4j seeded.")


def seed_cassandra():
    print("Seeding Cassandra...")

    cluster = Cluster([CASSANDRA_HOST])
    session = cluster.connect(CASSANDRA_KEYSPACE)

    insert_sensor = session.prepare("""
    INSERT INTO sensor_readings (
        sensor_id, reading_time, metric_type, value, unit, quality_flag
    ) VALUES (?, ?, ?, ?, ?, ?)
    """)

    insert_dashboard = session.prepare("""
    INSERT INTO sensor_readings_by_time (
        time_window_start, reading_time, sensor_id, metric_type, value, unit, quality_flag
    ) VALUES (?, ?, ?, ?, ?, ?, ?)
    """)

    base_time = datetime(2026, 5, 2, 12, 0, 0)
    sensor_ids = [f"sensor-{i:02d}" for i in range(1, 21)]
    metric_types = ["voltage", "current", "power_factor", "temp"]

    for i in range(50_000):
        sensor_id = sensor_ids[i % 20]
        reading_time = base_time + timedelta(seconds=i)
        metric_type = metric_types[i % 4]

        if metric_type == "voltage":
            value, unit = round(random.uniform(220, 245), 2), "V"
        elif metric_type == "current":
            value, unit = round(random.uniform(10, 120), 2), "A"
        elif metric_type == "power_factor":
            value, unit = round(random.uniform(0.85, 1.0), 3), "ratio"
        else:
            value, unit = round(random.uniform(20, 80), 2), "C"

        quality_flag = 0
        bucket = reading_time.replace(second=0, microsecond=0)

        session.execute(insert_sensor, (sensor_id, reading_time, metric_type, value, unit, quality_flag))
        session.execute(insert_dashboard, (bucket, reading_time, sensor_id, metric_type, value, unit, quality_flag))

        if i % 10_000 == 0:
            print(f"  Cassandra inserted {i} readings...")

    cluster.shutdown()
    print("Cassandra seeded.")


async def seed_mongo():
    print("Seeding MongoDB...")

    client = AsyncIOMotorClient(MONGO_URI)
    db = client[MONGO_DB]

    await db.equipment.create_index("asset_id", unique=True)

    docs = []

    for i in range(1, 11):
        docs.append({
            "asset_id": f"TX_META_{i:03d}",
            "equipment_type": "transformer",
            "manufacturer": "ABB",
            "model": "ONAN-400",
            "metadata": {
                "rating_kva": 400,
                "cooling": "oil",
                "tap_positions": 5,
                "last_oil_test": "2026-04-01"
            }
        })

    for i in range(1, 11):
        docs.append({
            "asset_id": f"SW_META_{i:03d}",
            "equipment_type": "switchgear",
            "manufacturer": "Siemens",
            "metadata": {
                "breaking_capacity_ka": 25,
                "insulation_type": "SF6",
                "remote_operable": True,
                "arc_flash_rating": "medium"
            }
        })

    for i in range(1, 11):
        docs.append({
            "asset_id": f"METER_META_{i:03d}",
            "equipment_type": "smart_meter",
            "manufacturer": "Landis+Gyr",
            "metadata": {
                "firmware_version": f"v{i}.2",
                "communication": "4G",
                "supports_remote_disconnect": i % 2 == 0,
                "custom_telemetry_fields": [f"field_{j}" for j in range(1, 41)]
            }
        })

    for doc in docs:
        await db.equipment.update_one(
            {"asset_id": doc["asset_id"]},
            {"$set": doc},
            upsert=True
        )

    client.close()
    print("MongoDB seeded.")


async def seed_postgres():
    print("Seeding PostgreSQL...")

    conn = await asyncpg.connect(
        host=POSTGRES_HOST,
        port=POSTGRES_PORT,
        user=POSTGRES_USER,
        password=POSTGRES_PASSWORD,
        database=POSTGRES_DB,
    )

    await conn.execute("""
    CREATE UNIQUE INDEX IF NOT EXISTS invoices_premise_month_uidx
    ON invoices (premise_id, billing_month)
    """)

    for i in range(1, 101):
        premise_id = f"PREM_{i:05d}"
        tariff_class = "commercial" if i % 5 == 0 else "residential"
        balance = round(random.uniform(0, 200), 2)
        invoice_amount = round(random.uniform(20, 180), 2)

        await conn.execute("""
        INSERT INTO accounts (premise_id, consumer_name, tariff_class, current_balance)
        VALUES ($1, $2, $3, $4)
        ON CONFLICT (premise_id)
        DO UPDATE SET
            consumer_name = EXCLUDED.consumer_name,
            tariff_class = EXCLUDED.tariff_class,
            current_balance = EXCLUDED.current_balance
        """, premise_id, f"Customer {i}", tariff_class, balance)

        await conn.execute("""
        INSERT INTO invoices (premise_id, billing_month, amount)
        VALUES ($1, $2, $3)
        ON CONFLICT (premise_id, billing_month)
        DO UPDATE SET amount = EXCLUDED.amount
        """, premise_id, "2026-05", invoice_amount)

    await conn.close()
    print("PostgreSQL seeded.")


async def main():
    seed_neo4j()
    seed_cassandra()
    await seed_mongo()
    await seed_postgres()
    print("All databases seeded successfully.")


if __name__ == "__main__":
    asyncio.run(main())
