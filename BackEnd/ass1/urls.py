# BackEnd/ass1/urls.py

from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import ProductViewSet, CartViewSet

router = DefaultRouter()
router.register(r'products', ProductViewSet, basename='product')
router.register(r'cart', CartViewSet, basename='cart')

# Generated URLs:
# /products/          -> GET (list), POST (create)
# /products/{id}/     -> GET, PUT, PATCH, DELETE
# /cart/my_cart/      -> GET (view cart)
# /cart/add/          -> POST (add item)
# /cart/remove/       -> DELETE (remove item)
# /cart/update_quantity/ -> PATCH (update quantity)

urlpatterns = [
    path('', include(router.urls)),
]