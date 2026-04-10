# BackEnd/ass1/urls.py

from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import ProductViewSet, CartViewSet

# 创建路由器，自动生成 URL 模式
router = DefaultRouter()
router.register(r'products', ProductViewSet, basename='product')   # 商品相关接口
router.register(r'cart', CartViewSet, basename='cart')             # 购物车接口

# 路由器会自动生成以下 URL：
# /products/          -> GET (列表), POST (创建)
# /products/{id}/     -> GET, PUT, PATCH, DELETE
# /cart/my_cart/      -> GET (查看购物车)
# /cart/add/          -> POST (添加商品)
# /cart/remove/       -> DELETE (删除商品)
# /cart/update_quantity/ -> PATCH (修改数量)

urlpatterns = [
    path('', include(router.urls)),
]