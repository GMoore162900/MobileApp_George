from fastapi.testclient import TestClient

from vehicle_api.main import app

client = TestClient(app)


def test_manufacturer_crud_flow():
    create_response = client.post(
        "/manufacturers",
        json={"name": "Ford", "country": "USA", "founded_year": 1903},
    )
    assert create_response.status_code == 201, create_response.text
    manufacturer = create_response.json()
    manufacturer_id = manufacturer["id"]

    assert manufacturer["name"] == "Ford"
    assert manufacturer["country"] == "USA"

    list_response = client.get("/manufacturers")
    assert list_response.status_code == 200
    assert any(item["id"] == manufacturer_id for item in list_response.json())

    vehicle_response = client.post(
        f"/manufacturers/{manufacturer_id}/vehicles",
        json={"make": "Ford", "model": "Mustang", "year": 1965},
    )
    assert vehicle_response.status_code == 201, vehicle_response.text
    vehicle = vehicle_response.json()
    assert vehicle["model"] == "Mustang"
    assert vehicle["manufacture_year"] == 1965

    detail_response = client.get(f"/manufacturers/{manufacturer_id}")
    assert detail_response.status_code == 200
    detail_payload = detail_response.json()
    assert any(item["model"] == "Mustang" for item in detail_payload["vehicles"])

    update_response = client.put(
        f"/vehicles/{vehicle['id']}",
        json={"make": "Ford", "model": "F-150", "year": 2024},
    )
    assert update_response.status_code == 200
    assert update_response.json()["model"] == "F-150"

    delete_response = client.delete(f"/vehicles/{vehicle['id']}")
    assert delete_response.status_code == 204

    delete_manufacturer_response = client.delete(f"/manufacturers/{manufacturer_id}")
    assert delete_manufacturer_response.status_code == 204
