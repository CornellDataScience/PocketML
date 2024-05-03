import json
from fastapi import APIRouter
from fastapi.responses import JSONResponse


router = APIRouter()


@router.get("/api/v1/jobs")
async def get_jobs():
    # TODO: HOW TO SPECIFY USER AND AUTHENTICATE?
    # /Users/anyayerramilli/CDS/PocketML-full-stack/PocketML-backend/app/test/sample_jobs/jobs1.json
    # "/../test/sample_jobs/jobs1.json"

    with open(
        "/Users/anyayerramilli/CDS/PocketML-full-stack/PocketML-backend/app/test/sample_jobs/jobs1.json",
        "r",
    ) as json_file:
        print(json_file)
        json_data = json.load(json_file)
        print("JSON DATA", json_data)
    return JSONResponse(json_data, status_code=200)
