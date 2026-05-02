from fastapi import FastAPI
from routers import grid
from db.neo4j import close_driver

app = FastAPI(title="GridSense API")

app.include_router(grid.router)

@app.get("/")
def root():
    return {"status": "GridSense API running"}

@app.get("/health")
def health():
    return {"status": "ok"}

@app.on_event("shutdown")
async def shutdown_event():
    await close_driver()
