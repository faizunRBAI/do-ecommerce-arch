import pytest
from django.test import Client


@pytest.mark.django_db
def test_health_returns_200():
    client = Client()
    response = client.get("/health/")
    assert response.status_code == 200


@pytest.mark.django_db
def test_health_payload():
    client = Client()
    response = client.get("/health/")
    data = response.json()
    assert data["status"] == "ok"
    assert "uptime" in data


@pytest.mark.django_db
def test_api_info_returns_200():
    client = Client()
    response = client.get("/api/info/")
    assert response.status_code == 200
