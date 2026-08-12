import pytest
from django.test import Client
from api.models import Category, Product


@pytest.mark.django_db
def test_home_returns_200():
    client = Client()
    response = client.get("/")
    assert response.status_code == 200


@pytest.mark.django_db
def test_home_with_products():
    cat = Category.objects.create(name="Test Category", slug="test-category")
    Product.objects.create(
        name="Test Product",
        slug="test-product",
        price="9.99",
        stock=10,
        category=cat,
        available=True,
    )
    client = Client()
    response = client.get("/")
    assert response.status_code == 200


@pytest.mark.django_db
def test_product_list_api():
    client = Client()
    response = client.get("/api/products/")
    assert response.status_code == 200
    data = response.json()
    assert "count" in data
    assert "results" in data


@pytest.mark.django_db
def test_product_list_api_with_data():
    cat = Category.objects.create(name="API Category", slug="api-category")
    Product.objects.create(
        name="API Product",
        slug="api-product",
        price="29.99",
        stock=5,
        category=cat,
        available=True,
    )
    client = Client()
    response = client.get("/api/products/")
    assert response.status_code == 200
    data = response.json()
    assert data["count"] == 1
    assert data["results"][0]["name"] == "API Product"
    assert data["results"][0]["category"] == "API Category"
