import csv
import time
import statistics
from pathlib import Path

import requests
import matplotlib.pyplot as plt


BASE_URL = "http://localhost:8000"
NODE_ID = "SS_002"
ITERATIONS_PER_DEPTH = 30
DEPTHS = range(1, 9)

RAW_FILE = Path("measurements/neo4j_traversal_raw.csv")
SUMMARY_FILE = Path("measurements/neo4j_traversal_summary.csv")
CHART_FILE = Path("measurements/neo4j_traversal_latency.png")


def percentile(values, p):
    values = sorted(values)
    index = int((p / 100) * len(values)) - 1
    index = max(0, min(index, len(values) - 1))
    return values[index]


def measure_once(depth):
    url = f"{BASE_URL}/grid/fault-impact/{NODE_ID}?max_depth={depth}"

    start = time.perf_counter()
    response = requests.get(url, timeout=10)
    end = time.perf_counter()

    latency_ms = (end - start) * 1000

    response.raise_for_status()
    data = response.json()

    return latency_ms, data.get("total_affected", 0)


def main():
    RAW_FILE.parent.mkdir(parents=True, exist_ok=True)

    raw_rows = []
    summary_rows = []

    for depth in DEPTHS:
        print(f"Measuring max_depth={depth}...")

        latencies = []
        affected_counts = []

        for i in range(1, ITERATIONS_PER_DEPTH + 1):
            latency_ms, affected = measure_once(depth)

            latencies.append(latency_ms)
            affected_counts.append(affected)

            raw_rows.append({
                "node_id": NODE_ID,
                "max_depth": depth,
                "iteration": i,
                "latency_ms": round(latency_ms, 3),
                "total_affected": affected,
            })

        p50 = statistics.median(latencies)
        p95 = percentile(latencies, 95)

        summary_rows.append({
            "node_id": NODE_ID,
            "max_depth": depth,
            "iterations": ITERATIONS_PER_DEPTH,
            "median_latency_ms": round(p50, 3),
            "p95_latency_ms": round(p95, 3),
            "min_latency_ms": round(min(latencies), 3),
            "max_latency_ms": round(max(latencies), 3),
            "avg_total_affected": round(statistics.mean(affected_counts), 2),
        })

    with RAW_FILE.open("w", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=raw_rows[0].keys())
        writer.writeheader()
        writer.writerows(raw_rows)

    with SUMMARY_FILE.open("w", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=summary_rows[0].keys())
        writer.writeheader()
        writer.writerows(summary_rows)

    depths = [row["max_depth"] for row in summary_rows]
    medians = [row["median_latency_ms"] for row in summary_rows]
    p95s = [row["p95_latency_ms"] for row in summary_rows]

    plt.figure()
    plt.plot(depths, medians, marker="o", label="Median latency")
    plt.plot(depths, p95s, marker="o", label="P95 latency")
    plt.xlabel("max_depth")
    plt.ylabel("Latency (ms)")
    plt.title("Neo4j Fault Impact Traversal Latency")
    plt.legend()
    plt.grid(True)
    plt.savefig(CHART_FILE, bbox_inches="tight")

    print(f"\nSaved raw results to {RAW_FILE}")
    print(f"Saved summary results to {SUMMARY_FILE}")
    print(f"Saved chart to {CHART_FILE}")

    print("\nSummary:")
    for row in summary_rows:
        print(row)


if __name__ == "__main__":
    main()
