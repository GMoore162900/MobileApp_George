from __future__ import annotations

from datetime import date
from typing import Any

from fastapi import FastAPI, HTTPException, status
from pydantic import BaseModel, Field

app = FastAPI(
    title="Vehicle Manufacturer API",
    version="1.0.0",
    description="CRUD API for managing vehicle manufacturers and their vehicle details.",
)


class VehicleCreate(BaseModel):
    make: str = Field(..., min_length=1, description="Manufacturer brand name")
    model: str = Field(..., min_length=1, description="Vehicle model")
    year: int = Field(
        ...,
        ge=1886,
        le=date.today().year + 1,
        description="Year the vehicle was manufactured",
    )


class VehicleUpdate(VehicleCreate):
    pass


class ManufacturerCreate(BaseModel):
    name: str = Field(..., min_length=1, description="Manufacturer name")
    country: str | None = Field(default=None, description="Country of origin")
    founded_year: int | None = Field(
        default=None,
        ge=1800,
        le=date.today().year,
        description="Year the manufacturer was founded",
    )


class ManufacturerUpdate(ManufacturerCreate):
    pass


in_memory_db: dict[str, dict[int, dict[str, Any]]] = {
    "manufacturers": {},
    "vehicles": {},
}

manufacturer_counter = 1
vehicle_counter = 1


def next_id(kind: str) -> int:
    global manufacturer_counter, vehicle_counter
    if kind == "manufacturer":
        current = manufacturer_counter
        manufacturer_counter += 1
        return current
    current = vehicle_counter
    vehicle_counter += 1
    return current


def serialize_vehicle(vehicle: dict[str, Any]) -> dict[str, Any]:
    return {
        "id": vehicle["id"],
        "manufacturer_id": vehicle["manufacturer_id"],
        "make": vehicle["make"],
        "model": vehicle["model"],
        "manufacture_year": vehicle["year"],
    }


def serialize_manufacturer(manufacturer: dict[str, Any]) -> dict[str, Any]:
    vehicles = [serialize_vehicle(vehicle) for vehicle in manufacturer["vehicles"].values()]
    return {
        "id": manufacturer["id"],
        "name": manufacturer["name"],
        "country": manufacturer["country"],
        "founded_year": manufacturer["founded_year"],
        "vehicles": vehicles,
    }


@app.get("/")
def root() -> dict[str, str]:
    return {"message": "Vehicle Manufacturer API is running"}


@app.get("/health")
def health_check() -> dict[str, str]:
    return {"status": "ok"}


@app.post("/manufacturers", status_code=status.HTTP_201_CREATED)
def create_manufacturer(payload: ManufacturerCreate) -> dict[str, Any]:
    manufacturer_id = next_id("manufacturer")
    manufacturer = {
        "id": manufacturer_id,
        "name": payload.name,
        "country": payload.country,
        "founded_year": payload.founded_year,
        "vehicles": {},
    }
    in_memory_db["manufacturers"][manufacturer_id] = manufacturer
    return serialize_manufacturer(manufacturer)


@app.get("/manufacturers")
def list_manufacturers() -> list[dict[str, Any]]:
    return [serialize_manufacturer(manufacturer) for manufacturer in in_memory_db["manufacturers"].values()]


@app.get("/manufacturers/{manufacturer_id}")
def get_manufacturer(manufacturer_id: int) -> dict[str, Any]:
    manufacturer = in_memory_db["manufacturers"].get(manufacturer_id)
    if manufacturer is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Manufacturer not found")
    return serialize_manufacturer(manufacturer)


@app.put("/manufacturers/{manufacturer_id}")
def update_manufacturer(manufacturer_id: int, payload: ManufacturerUpdate) -> dict[str, Any]:
    manufacturer = in_memory_db["manufacturers"].get(manufacturer_id)
    if manufacturer is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Manufacturer not found")

    manufacturer["name"] = payload.name
    manufacturer["country"] = payload.country
    manufacturer["founded_year"] = payload.founded_year
    return serialize_manufacturer(manufacturer)


@app.delete("/manufacturers/{manufacturer_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_manufacturer(manufacturer_id: int) -> None:
    manufacturer = in_memory_db["manufacturers"].pop(manufacturer_id, None)
    if manufacturer is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Manufacturer not found")

    for vehicle_id in list(manufacturer["vehicles"].keys()):
        in_memory_db["vehicles"].pop(vehicle_id, None)


@app.post("/manufacturers/{manufacturer_id}/vehicles", status_code=status.HTTP_201_CREATED)
def create_vehicle_for_manufacturer(manufacturer_id: int, payload: VehicleCreate) -> dict[str, Any]:
    manufacturer = in_memory_db["manufacturers"].get(manufacturer_id)
    if manufacturer is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Manufacturer not found")

    vehicle_id = next_id("vehicle")
    vehicle = {
        "id": vehicle_id,
        "manufacturer_id": manufacturer_id,
        "make": payload.make,
        "model": payload.model,
        "year": payload.year,
    }
    in_memory_db["vehicles"][vehicle_id] = vehicle
    manufacturer["vehicles"][vehicle_id] = vehicle
    return serialize_vehicle(vehicle)


@app.get("/vehicles")
def list_vehicles() -> list[dict[str, Any]]:
    return [serialize_vehicle(vehicle) for vehicle in in_memory_db["vehicles"].values()]


@app.get("/vehicles/{vehicle_id}")
def get_vehicle(vehicle_id: int) -> dict[str, Any]:
    vehicle = in_memory_db["vehicles"].get(vehicle_id)
    if vehicle is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Vehicle not found")
    return serialize_vehicle(vehicle)


@app.put("/vehicles/{vehicle_id}")
def update_vehicle(vehicle_id: int, payload: VehicleUpdate) -> dict[str, Any]:
    vehicle = in_memory_db["vehicles"].get(vehicle_id)
    if vehicle is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Vehicle not found")

    vehicle["make"] = payload.make
    vehicle["model"] = payload.model
    vehicle["year"] = payload.year

    manufacturer = in_memory_db["manufacturers"].get(vehicle["manufacturer_id"])
    if manufacturer is not None:
        manufacturer["vehicles"][vehicle_id] = vehicle

    return serialize_vehicle(vehicle)


@app.delete("/vehicles/{vehicle_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_vehicle(vehicle_id: int) -> None:
    vehicle = in_memory_db["vehicles"].pop(vehicle_id, None)
    if vehicle is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Vehicle not found")

    manufacturer = in_memory_db["manufacturers"].get(vehicle["manufacturer_id"])
    if manufacturer is not None:
        manufacturer["vehicles"].pop(vehicle_id, None)
