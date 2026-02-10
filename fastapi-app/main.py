from fastapi import FastAPI

app = FastAPI(title="FastAPI AWS ECS Demo")


@app.get("/")
def read_root():
    return {"message": "Hello World from FastAPI on AWS ECS Fargate!"}


@app.get("/health")
def health_check():
    return {"status": "healthy"}
