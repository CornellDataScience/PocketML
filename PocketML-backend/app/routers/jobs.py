import json
from fastapi import APIRouter
from fastapi.responses import FileResponse


router = APIRouter()


@router.get("/api/v1/jobs")
async def get_jobs():
    # TODO: HOW TO SPECIFY USER AND AUTHENTICATE?
    with open("PocketML-backend/test/sample_jobs/jobs1.json", "r") as json_file:
        json_data = json.load(json_file)
    return FileResponse(json_data, media_type="application/json", status_code=200)
