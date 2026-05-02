from fastapi import APIRouter, HTTPException
from db.mongo import get_mongo_db
from models.mongo import EquipmentCreate, EquipmentUpdate

router = APIRouter(prefix="/equipment", tags=["Equipment"])

@router.post("")
async def create_equipment(payload: EquipmentCreate):
    db = get_mongo_db()

    doc = payload.model_dump()
    result = await db.equipment.update_one(
        {"asset_id": payload.asset_id},
        {"$set": doc},
        upsert=True
    )

    return {
        "status": "created_or_updated",
        "asset_id": payload.asset_id,
        "upserted": result.upserted_id is not None
    }

@router.get("/{asset_id}")
async def get_equipment(asset_id: str):
    db = get_mongo_db()

    doc = await db.equipment.find_one(
        {"asset_id": asset_id},
        {"_id": 0}
    )

    if doc is None:
        raise HTTPException(status_code=404, detail="Equipment not found")

    return doc

@router.patch("/{asset_id}")
async def update_equipment(asset_id: str, payload: EquipmentUpdate):
    db = get_mongo_db()

    updates = {
        k: v for k, v in payload.model_dump(exclude_unset=True).items()
        if v is not None
    }

    if not updates:
        raise HTTPException(status_code=400, detail="No update fields provided")

    result = await db.equipment.update_one(
        {"asset_id": asset_id},
        {"$set": updates}
    )

    if result.matched_count == 0:
        raise HTTPException(status_code=404, detail="Equipment not found")

    return {"status": "updated", "asset_id": asset_id}
