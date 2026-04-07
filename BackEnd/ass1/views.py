from django.shortcuts import render
from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from django.shortcuts import get_object_or_404
from .models import Product, Cart, CartItem
from .serializers import (
    ProductSerializer, 
    CartSerializer, 
    CartItemSerializer, 
    AddToCartSerializer
)

# Create your views here.
# BackEnd/ass1/views.py

# 1. 商品视图集：提供标准的 CRUD 接口
class ProductViewSet(viewsets.ModelViewSet):
    """
    商品视图集，自动生成以下接口：
    GET /products/         - 获取所有商品
    POST /products/        - 创建新商品
    GET /products/{id}/    - 获取单个商品
    PUT /products/{id}/    - 完整更新商品
    PATCH /products/{id}/  - 部分更新商品
    DELETE /products/{id}/ - 删除商品
    """
    queryset = Product.objects.all()
    serializer_class = ProductSerializer
    # permission_classes = [IsAuthenticated]  # 如需登录才能操作，可取消注释


# 2. 购物车视图集（自定义，因为购物车通常与用户关联，且需要特殊操作）
class CartViewSet(viewsets.GenericViewSet):
    """
    购物车视图集，提供：
    GET /cart/             - 获取当前用户的购物车内容
    POST /cart/add/        - 添加商品到购物车
    POST /cart/update/     - 更新购物车中某个商品的数量
    DELETE /cart/remove/   - 从购物车中移除某个商品
    DELETE /cart/clear/    - 清空购物车
    """
    permission_classes = [IsAuthenticated]  # 需要登录才能使用购物车

    def get_cart(self, user):
        """获取或创建当前用户的购物车"""
        cart, created = Cart.objects.get_or_create(user=user)
        return cart

    def list(self, request):
        """GET /cart/ - 返回当前用户的购物车内容"""
        cart = self.get_cart(request.user)
        serializer = CartSerializer(cart)
        return Response(serializer.data)

    @action(detail=False, methods=['post'])
    def add(self, request):
        """
        POST /cart/add/ - 添加商品到购物车
        请求体: {"product_id": 1, "quantity": 2}  (quantity 可选，默认为1)
        """
        serializer = AddToCartSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        
        product_id = serializer.validated_data['product_id']
        quantity = serializer.validated_data['quantity']
        
        product = get_object_or_404(Product, pk=product_id)
        cart = self.get_cart(request.user)
        
        # 检查购物车中是否已有该商品
        cart_item, created = CartItem.objects.get_or_create(
            cart=cart,
            product=product,
            defaults={'quantity': quantity}
        )
        if not created:
            # 如果已存在，增加数量
            cart_item.quantity += quantity
            cart_item.save()
        
        # 返回更新后的购物车内容
        cart_serializer = CartSerializer(cart)
        return Response(cart_serializer.data, status=status.HTTP_200_OK)

    @action(detail=False, methods=['post'])
    def update(self, request):
        """
        POST /cart/update/ - 更新购物车中某个商品的数量
        请求体: {"product_id": 1, "quantity": 5}
        """
        product_id = request.data.get('product_id')
        quantity = request.data.get('quantity')
        
        if not product_id or quantity is None:
            return Response(
                {"error": "product_id and quantity are required"},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        cart = self.get_cart(request.user)
        cart_item = get_object_or_404(CartItem, cart=cart, product_id=product_id)
        
        if quantity <= 0:
            # 如果数量 <= 0，删除该条目
            cart_item.delete()
        else:
            cart_item.quantity = quantity
            cart_item.save()
        
        cart_serializer = CartSerializer(cart)
        return Response(cart_serializer.data)

    @action(detail=False, methods=['delete'])
    def remove(self, request):
        """
        DELETE /cart/remove/ - 从购物车中移除某个商品
        请求体: {"product_id": 1}
        """
        product_id = request.data.get('product_id')
        if not product_id:
            return Response(
                {"error": "product_id is required"},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        cart = self.get_cart(request.user)
        CartItem.objects.filter(cart=cart, product_id=product_id).delete()
        
        cart_serializer = CartSerializer(cart)
        return Response(cart_serializer.data)

    @action(detail=False, methods=['delete'])
    def clear(self, request):
        """
        DELETE /cart/clear/ - 清空购物车
        """
        cart = self.get_cart(request.user)
        cart.items.all().delete()
        cart_serializer = CartSerializer(cart)
        return Response(cart_serializer.data)