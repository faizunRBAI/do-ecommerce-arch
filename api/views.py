import os
import time

from django.core.cache import cache
from django.http import HttpResponse, JsonResponse
from django.shortcuts import render
from rest_framework.decorators import api_view
from rest_framework.response import Response

from .models import Category, Product
from .welcome import WELCOME_HTML

_start = time.time()


def home(request):
    """Storefront landing page - renders the product catalogue."""
    products = cache.get("storefront_products")
    if products is None:
        products = list(
            Product.objects.filter(available=True).select_related("category").order_by("-created_at")[:12]
        )
        cache.set("storefront_products", products, timeout=120)

    categories = cache.get("storefront_categories")
    if categories is None:
        categories = list(Category.objects.all())
        cache.set("storefront_categories", categories, timeout=300)

    try:
        return render(request, "storefront.html", {"products": products, "categories": categories})
    except Exception:
        return HttpResponse(WELCOME_HTML, content_type="text/html")


@api_view(["GET"])
def health(request):
    """Health-check endpoint used by the DO Load Balancer and verify stage."""
    return JsonResponse({"status": "ok", "uptime": round(time.time() - _start, 1)})


@api_view(["GET"])
def api_info(request):
    """Runtime info - useful for verify/debug."""
    import django

    return JsonResponse(
        {
            "app": "do-ecommerce-arch",
            "django_version": django.__version__,
            "db": "connected" if os.environ.get("DATABASE_URL") else "sqlite",
            "cache": "redis" if os.environ.get("REDIS_URL") else "local",
            "spaces": "enabled" if os.environ.get("SPACES_BUCKET") else "disabled",
        }
    )


@api_view(["GET"])
def product_list(request):
    """JSON product catalogue - for SPA / mobile consumers."""
    products = (
        Product.objects.filter(available=True).select_related("category").order_by("-created_at")[:50]
    )
    data = [
        {
            "id": p.id,
            "name": p.name,
            "slug": p.slug,
            "description": p.description,
            "price": str(p.price),
            "stock": p.stock,
            "category": p.category.name if p.category else None,
            "image_url": p.image.url if p.image else None,
        }
        for p in products
    ]
    return Response({"count": len(data), "results": data})
