from django.urls import path

from . import views

urlpatterns = [
    path("", views.home, name="home"),
    path("health/", views.health, name="health"),
    path("api/info/", views.api_info, name="api_info"),
    path("api/products/", views.product_list, name="product_list"),
]
