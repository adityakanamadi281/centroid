from fastapi import FastAPI

app = FastAPI(title="Centroid")


@app.get("/health")
async def health():
    return {"status": "ok"}

@app.get("/hi")
async def hi():
    return {"message": "Hello, world!"}
