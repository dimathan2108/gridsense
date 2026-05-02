import os
from motor.motor_asyncio import AsyncIOMotorClient

_client = None

def get_mongo_db():
    global _client
    if _client is None:
        uri = os.getenv("MONGO_URI")
        database = os.getenv("MONGO_DATABASE", "gridsense")
        _client = AsyncIOMotorClient(uri)
    return _client[os.getenv("MONGO_DATABASE", "gridsense")]
