from fastapi import FastAPI

app = FastAPI()

@app.get("/")
async def root():
    return {"message": "Hello World"}

@app.post("/data")
async def post_data(item):
    return item

@app.get("/gg")
async def gg():
    return {"message": "Good game"}

# @app.get("/username/{project_name}")
# async def init_project(username, project_name):
#     pass

# @app.post("/{username}/{project}")
# async def create_project(username: str, project: str):
#     return item