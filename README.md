⚡ GridSense – Setup & Execution Guide <br />
📦 Prerequisites

Make sure you have installed:

Docker <br />
Docker Compose <br />
Python 3.10+ (for seeding script)

1. Start the system

From the project root:

docker compose up --build

This will:

Start all services (Cassandra, Neo4j, MongoDB, PostgreSQL, Redis, API) <br />
Automatically initialize: <br />
Cassandra schema (init.cql) <br />
PostgreSQL schema (init.sql) <br />

Note that port numbers have been changed for Redis and PostgreSQL from the default template that is recommended in case of port conflicts!

2. Prepare Python environment (for seeding)

Create a virtual environment:

python3 -m venv venv
source venv/bin/activate

Install dependencies:

pip install -r api/requirements.txt


3. Seed all databases

Run:

python scripts/seed.py

This script will:

Populate Neo4j with 10 substations, 10 feeders, 40 transformers, 200 smart meters <br />
Insert 50,000 time series readings into Cassandra <br />
Insert 30 heterogenous equipment documents into MongoDB <br />
Insert 100 accounts and invoices into PostgreSQL <br />

✔ The script is idempotent (safe to run multiple times)
