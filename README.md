⚡ GridSense – Setup & Execution Guide
📦 Prerequisites

Make sure you have installed:

Docker
Docker Compose
Python 3.10+ (for seeding script)

🚀 1. Start the system

From the project root:

docker compose up --build

This will:

Start all services (Cassandra, Neo4j, MongoDB, PostgreSQL, Redis, API)
Automatically initialize:
Cassandra schema (init.cql)
PostgreSQL schema (init.sql)

🐍 2. Prepare Python environment (for seeding)

Create a virtual environment:

python3 -m venv venv
source venv/bin/activate

Install dependencies:

pip install -r api/requirements.txt


🌱 3. Seed all databases

Run:

python scripts/seed.py

This script will:

Populate Neo4j with:
10 substations
40 transformers
200 smart meters
Insert 50,000 time-series readings into Cassandra
Insert 30 heterogeneous equipment documents into MongoDB
Insert 100 accounts and invoices into PostgreSQL

✔ The script is idempotent (safe to run multiple times)
