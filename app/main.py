from fastapi import FastAPI

app = FastAPI(title="Centroid")


@app.get("/health")
async def health():
    return {"status": "ok"}
