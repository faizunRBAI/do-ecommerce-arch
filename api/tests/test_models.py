import pytest

from api.models import Category, Product


@pytest.mark.django_db
def test_category_creation():
    cat = Category.objects.create(name="Electronics", slug="electronics")
    assert cat.pk is not None
    assert str(cat) == "Electronics"


@pytest.mark.django_db
def test_product_creation():
    cat = Category.objects.create(name="Apparel", slug="apparel")
    product = Product.objects.create(
        name="Blue T-Shirt",
        slug="blue-t-shirt",
        price="19.99",
        stock=100,
        category=cat,
    )
    assert product.pk is not None
    assert str(product) == "Blue T-Shirt"
    assert product.available is True
    assert str(product.price) == "19.99"


@pytest.mark.django_db
def test_product_without_category():
    product = Product.objects.create(
        name="Mystery Item",
        slug="mystery-item",
        price="5.00",
        stock=0,
    )
    assert product.category is None
    assert product.available is True
