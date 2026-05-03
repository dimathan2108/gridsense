import csv
import time
import statistics
from pathlib import Path
from datetime import datetime, timedelta
from collections import defaultdict
from concurrent.futures import ThreadPoolExecutor, as_completed

from cassandra.cluster import Cluster
from cassandra import ConsistencyLevel


HOST = "127.0.0.1"
KEYSPACE = "gridsense"

TOTAL_WRITES = 10_000
WORKERS = 32
RUNS_PER_LEVEL = 5

OUTPUT_FILE = Path("measurements/cassandra_consistency_results.csv")
AVG_FILE = Path("measurements/cassandra_consistency_averages.csv")

CONSISTENCY_LEVELS = {
    "ONE": ConsistencyLevel.ONE,
    "LOCAL_QUORUM": ConsistencyLevel.LOCAL_QUORUM,
    "ALL": ConsistencyLevel.ALL,
}


def write_one(session, statement, i, cl_name):
    sensor_id = f"measure-{cl_name.lower()}-{i % 20}"
    reading_time = datetime.utcnow() + timedelta(microseconds=i)

    start = time.perf_counter()
    session.execute(
        statement,
        (sensor_id, reading_time, "voltage", 230.0 + (i % 10), "V", 0),
    )
    end = time.perf_counter()

    return (end - start) * 1000


def run_test(cl_name, cl_value, run_id):
    cluster = Cluster([HOST])
    session = cluster.connect(KEYSPACE)

    query = """
    INSERT INTO sensor_readings (
        sensor_id, reading_time, metric_type, value, unit, quality_flag
    ) VALUES (?, ?, ?, ?, ?, ?)
    """

    statement = session.prepare(query)
    statement.consistency_level = cl_value

    latencies = []
    errors = 0

    print(f"\nRunning {cl_name}, run {run_id}")

    start_time = time.perf_counter()

    with ThreadPoolExecutor(max_workers=WORKERS) as executor:
        futures = [
            executor.submit(write_one, session, statement, i, cl_name)
            for i in range(TOTAL_WRITES)
        ]

        for future in as_completed(futures):
            try:
                latencies.append(future.result())
            except Exception:
                errors += 1

    duration = time.perf_counter() - start_time
    cluster.shutdown()

    successful = len(latencies)
    throughput = successful / duration if duration > 0 else 0

    latencies_sorted = sorted(latencies)
    p50 = statistics.median(latencies_sorted) if latencies_sorted else None
    p95 = (
        latencies_sorted[int(0.95 * len(latencies_sorted)) - 1]
        if latencies_sorted
        else None
    )

    return {
        "consistency": cl_name,
        "run": run_id,
        "writes_attempted": TOTAL_WRITES,
        "writes_successful": successful,
        "errors": errors,
        "duration_seconds": round(duration, 2),
        "throughput_events_per_second": round(throughput, 2),
        "p50_latency_ms": round(p50, 2) if p50 is not None else None,
        "p95_latency_ms": round(p95, 2) if p95 is not None else None,
    }


def compute_averages(results):
    grouped = defaultdict(list)

    for r in results:
        grouped[r["consistency"]].append(r)

    averages = []

    for cl, runs in grouped.items():
        total_errors = sum(r["errors"] for r in runs)
        total_attempts = sum(r["writes_attempted"] for r in runs)

        averages.append({
            "consistency": cl,
            "runs": len(runs),
            "avg_duration_seconds": round(sum(r["duration_seconds"] for r in runs) / len(runs), 2),
            "avg_throughput_events_per_second": round(sum(r["throughput_events_per_second"] for r in runs) / len(runs), 2),
            "avg_p50_latency_ms": round(sum(r["p50_latency_ms"] for r in runs) / len(runs), 2),
            "avg_p95_latency_ms": round(sum(r["p95_latency_ms"] for r in runs) / len(runs), 2),
            "total_errors": total_errors,
            "error_rate_percent": round((total_errors / total_attempts) * 100, 4),
        })

    return averages


def save_csv(path, rows):
    path.parent.mkdir(parents=True, exist_ok=True)

    with path.open("w", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=rows[0].keys())
        writer.writeheader()
        writer.writerows(rows)


def main():
    results = []

    for run_id in range(1, RUNS_PER_LEVEL + 1):
        for cl_name, cl_value in CONSISTENCY_LEVELS.items():
            results.append(run_test(cl_name, cl_value, run_id))

    averages = compute_averages(results)

    save_csv(OUTPUT_FILE, results)
    save_csv(AVG_FILE, averages)

    print(f"\nSaved raw results to {OUTPUT_FILE}")
    print(f"Saved averages to {AVG_FILE}")

    print("\nAVERAGES")
    for row in averages:
        print(row)


if __name__ == "__main__":
    main()
