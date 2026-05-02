from fastapi import FastAPI
from routers import sensors, grid, equipment, billing, alerts
from db.neo4j import close_driver

app = FastAPI(title="GridSense API")

app.include_router(sensors.router)
app.include_router(grid.router)
app.include_router(equipment.router)
app.include_router(billing.router)
app.include_router(alerts.router)

@app.get("/")
def root():
    return {"status": "GridSense API running"}

@app.get("/health")
def health():
    return {"status": "ok"}

@app.on_event("shutdown")
async def shutdown_event():
    await close_driver()
