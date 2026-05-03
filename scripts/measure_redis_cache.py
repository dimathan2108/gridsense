import csv
import time
import random
import statistics
from pathlib import Path
from datetime import datetime, timedelta

import requests
from cassandra.cluster import Cluster


BASE_URL = "http://localhost:8000"
KEYSPACE = "gridsense"
CASSANDRA_HOST = "127.0.0.1"

SENSOR_COUNT = 500
REQUESTS = 500

RAW_FILE = Path("measurements/redis_cache_raw.csv")
SUMMARY_FILE = Path("measurements/redis_cache_summary.csv")


def percentile(values, p):
    values = sorted(values)
    index = int(len(values) * p / 100) - 1
    return values[max(0, min(index, len(values) - 1))]



def seed_sensors():
    print("Seeding 500 sensors into Cassandra...")

    cluster = Cluster([CASSANDRA_HOST])
    session = cluster.connect(KEYSPACE)

    query = """
    INSERT INTO sensor_readings (
        sensor_id, reading_time, metric_type, value, unit, quality_flag
    ) VALUES (?, ?, ?, ?, ?, ?)
    """

    statement = session.prepare(query)

    now = datetime.utcnow()

    for i in range(1, SENSOR_COUNT + 1):
        sensor_id = f"sensor-{i:03d}"

        # insert ~10 readings per sensor
        for j in range(10):
            session.execute(
                statement,
                (
                    sensor_id,
                    now - timedelta(minutes=j * 5),
                    "voltage",
                    220 + random.random() * 20,
                    "V",
                    0,
                ),
            )

    cluster.shutdown()
    print("Seeding complete.")


def request_summary(sensor_id):
    start = time.perf_counter()
    r = requests.get(f"{BASE_URL}/sensors/{sensor_id}/summary", timeout=10)
    latency = (time.perf_counter() - start) * 1000

    r.raise_for_status()
    return latency, r.json().get("cached", False)


def run_phase(label, sensor_ids):
    rows = []

    print(f"\nRunning {label} phase...")

    for i, sensor_id in enumerate(sensor_ids):
        latency, cached = request_summary(sensor_id)

        rows.append({
            "phase": label,
            "iteration": i + 1,
            "sensor_id": sensor_id,
            "latency_ms": round(latency, 3),
            "cached": cached,
        })

    return rows


def summarize(rows):
    latencies = [r["latency_ms"] for r in rows]
    hits = sum(1 for r in rows if r["cached"])

    return {
        "phase": rows[0]["phase"],
        "requests": len(rows),
        "p50_latency_ms": round(statistics.median(latencies), 3),
        "p95_latency_ms": round(percentile(latencies, 95), 3),
        "p99_latency_ms": round(percentile(latencies, 99), 3),
        "cache_hit_rate_percent": round((hits / len(rows)) * 100, 2),
    }


def save_csv(path, rows):
    path.parent.mkdir(parents=True, exist_ok=True)

    with path.open("w", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=rows[0].keys())
        writer.writeheader()
        writer.writerows(rows)


def main():
    # Step 1: seed data
    seed_sensors()

    sensor_ids = [f"sensor-{i:03d}" for i in range(1, SENSOR_COUNT + 1)]

    print("\n=== WARM CACHE PHASE ===")

    # Warm all keys
    for sensor_id in sensor_ids:
        request_summary(sensor_id)

    # Measure warm cache (500 requests)
    warm_rows = run_phase("warm", sensor_ids[:REQUESTS])

    print("\nWaiting 31 seconds for TTL expiry...")
    time.sleep(31)

    print("\n=== COLD CACHE PHASE ===")

    # Measure cold cache (each sensor once → true misses)
    cold_rows = run_phase("cold", sensor_ids[:REQUESTS])

    raw_rows = warm_rows + cold_rows
    summary_rows = [summarize(warm_rows), summarize(cold_rows)]

    save_csv(RAW_FILE, raw_rows)
    save_csv(SUMMARY_FILE, summary_rows)

    print(f"\nSaved raw results to {RAW_FILE}")
    print(f"Saved summary results to {SUMMARY_FILE}")

    print("\nSUMMARY")
    for r in summary_rows:
        print(r)


if __name__ == "__main__":
    main()
