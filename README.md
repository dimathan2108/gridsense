
# GridSense – Distributed Data Platform

## Overview

GridSense is a distributed data platform for managing smart grid infrastructure. It integrates multiple databases, each chosen for a specific workload:

- Time-series ingestion and querying  
- Graph-based topology traversal  
- Flexible equipment metadata storage  
- Transactional billing  
- Low-latency caching and alerting  

The system is exposed through a unified FastAPI service.

---

## Environment Requirements

Ensure the following are installed:

- Docker  
- Docker Compose  
- Python 3.10+  

---

## Startup Instructions

### 1. Start all services

From the project root:

```bash
docker compose up --build
```

This will:

- Start all services:
  - Cassandra
  - Neo4j
  - MongoDB
  - PostgreSQL
  - Redis
  - FastAPI API

- Automatically initialize:
  - Cassandra schema (`init.cql`)
  - PostgreSQL schema (`init.sql`)

Note:  
Custom ports are used for PostgreSQL and Redis to avoid conflicts with local installations.

---

### 2. Prepare Python environment (for seeding)

```bash
python3 -m venv venv
source venv/bin/activate
pip install -r api/requirements.txt
```

---

### 3. Seed all databases

```bash
python scripts/seed.py
```

This script:

- Populates Neo4j with:
  - 1 grid supply point
  - 10 substations
  - 10 feeders
  - 40 transformers
  - 200 smart meters

- Inserts:
  - 50,000 time-series readings into Cassandra  
  - 30 heterogeneous equipment documents into MongoDB  
  - 100 accounts and invoices into PostgreSQL  

The script is idempotent and can be safely re-run.

---

## System Architecture

Each service is responsible for a distinct workload:

### Cassandra (Time-Series Data)
- Stores high-volume sensor readings  
- Optimized for write-heavy workloads  
- Supports time-window queries for dashboards  

### Neo4j (Grid Topology)
- Models the electrical network as a graph  
- Enables traversal queries (fault impact, restoration paths)  

### MongoDB (Equipment Metadata)
- Stores flexible, schema-less equipment data  
- Supports heterogeneous document structures  

### PostgreSQL (Billing)
- Manages transactional data (accounts, invoices)  
- Ensures ACID compliance and consistency  

### Redis (Caching & Alerts)
- Caches sensor summaries for fast retrieval  
- Stores active alerts and supports pub/sub  

### FastAPI (API Layer)
- Provides a unified interface to all services  
- Implements business logic and orchestration  

---

## Example API Calls

These commands can be copied directly into a terminal.

### Cassandra – Sensor Readings

```bash
curl -X POST http://localhost:8000/sensors/readings -H "Content-Type: application/json" -d '{
  "readings": [{
    "sensor_id": "sensor-01",
    "reading_time": "2026-05-02T12:00:00",
    "metric_type": "voltage",
    "value": 230.5,
    "unit": "V",
    "quality_flag": 0
  }]
}'
```

```bash
curl "http://localhost:8000/sensors/sensor-01/readings?limit=5"
```

```bash
curl "http://localhost:8000/sensors/sensor-01/summary"
```

---

### Neo4j – Grid Topology

```bash
curl "http://localhost:8000/grid/fault-impact/SS_002?max_depth=6"
```

```bash
curl "http://localhost:8000/grid/restore-paths/TX_005?max_depth=6"
```

```bash
curl -X POST http://localhost:8000/grid/nodes -H "Content-Type: application/json" -d '{
  "node_type": "Transformer",
  "node_id": "TX_TEST",
  "properties": {
    "name": "Test transformer",
    "rating_kva": 500,
    "status": "normal"
  }
}'
```

```bash
curl -X POST http://localhost:8000/grid/relationships -H "Content-Type: application/json" -d '{
  "from_id": "F_001",
  "to_id": "TX_TEST",
  "relationship_type": "CONNECTS_TO",
  "properties": {
    "distance_m": 150
  }
}'
```

---

### MongoDB – Equipment Metadata

```bash
curl -X POST http://localhost:8000/equipment -H "Content-Type: application/json" -d '{
  "asset_id": "TX_META_TEST",
  "equipment_type": "transformer",
  "manufacturer": "ABB",
  "model": "ONAN-400",
  "metadata": {
    "rating_kva": 400,
    "cooling": "oil",
    "tap_positions": 5,
    "last_oil_test": "2026-04-01"
  }
}'
```

```bash
curl "http://localhost:8000/equipment/TX_META_TEST"
```

```bash
curl -X PATCH http://localhost:8000/equipment/TX_META_TEST -H "Content-Type: application/json" -d '{
  "metadata": {
    "inspection_status": "passed",
    "last_checked": "2026-05-03"
  }
}'
```

---

### PostgreSQL – Billing

```bash
curl "http://localhost:8000/billing/account/PREM_00001"
```

```bash
curl -X POST http://localhost:8000/billing/invoice -H "Content-Type: application/json" -d '{
  "premise_id": "PREM_00001",
  "billing_month": "2026-06",
  "usage_kwh": 350
}'
```

---

### Redis – Alerts

```bash
curl -X POST http://localhost:8000/alerts/publish -H "Content-Type: application/json" -d '{
  "node_id": "TX_001",
  "severity": "high",
  "message": "Transformer overload detected"
}'
```

```bash
curl "http://localhost:8000/alerts/active"
```

---

## Notes

- All services run within Docker and communicate over an internal network  
- Data persists across container restarts via Docker volumes  
- The system demonstrates polyglot persistence and workload-specific database selection 
