# Vehicle Manufacturer API

A FastAPI-based CRUD service for tracking vehicle manufacturers and the vehicles they produce.

## Features

- Create, read, update, and delete manufacturers
- Create, read, update, and delete vehicles
- In-memory storage for quick local development
- `uv` project structure for clean dependency management

## Setup

```bash
cd code/genai_code/vehicle_api_george
uv sync --dev
uv run uvicorn vehicle_api.main:app --reload
```

Then open:

- http://127.0.0.1:8000/docs

## Example endpoints

- `POST /manufacturers`
- `GET /manufacturers`
- `GET /manufacturers/{manufacturer_id}`
- `PUT /manufacturers/{manufacturer_id}`
- `DELETE /manufacturers/{manufacturer_id}`
- `POST /manufacturers/{manufacturer_id}/vehicles`
- `GET /vehicles`
- `GET /vehicles/{vehicle_id}`
- `PUT /vehicles/{vehicle_id}`
- `DELETE /vehicles/{vehicle_id}`

## Example payload

```json
{
  "name": "Ford",
  "country": "USA",
  "founded_year": 1903
}
```

```json
{
  "make": "Ford",
  "model": "Mustang",
  "year": 1965
}
```
