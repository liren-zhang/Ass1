from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from django.shortcuts import get_object_or_404
from .models import Product, Cart, CartItem
from .serializers import ProductSerializer, CartSerializer, CartItemSerializer, AddToCartSerializer

# Create your views here.
# BackEnd/ass1/views.py

# 1. 商品视图集（自动提供 CRUD 接口）
class ProductViewSet(viewsets.ModelViewSet):
    """
    商品 API：
    - GET /products/          -> 获取所有商品
    - POST /products/         -> 创建新商品
    - GET /products/{id}/     -> 获取单个商品
    - PUT /products/{id}/     -> 更新整个商品
    - PATCH /products/{id}/   -> 部分更新商品
    - DELETE /products/{id}/  -> 删除商品
    """
    queryset = Product.objects.all()
    serializer_class = ProductSerializer
    # 可选：添加权限，让只有登录用户才能操作（先注释，开发阶段方便测试）
    # permission_classes = [IsAuthenticated]


# 2. 购物车视图集（自定义操作，不使用默认的全部 CRUD）
class CartViewSet(viewsets.GenericViewSet):
    """
    购物车 API：
    - GET /cart/              -> 获取当前用户的购物车
    - POST /cart/add/         -> 添加商品到购物车
    - DELETE /cart/remove/    -> 从购物车移除商品
    - PATCH /cart/update/     -> 更新购物车中商品的数量
    """
    permission_classes = [IsAuthenticated]  # 要求登录（开发时可暂时注释）

    def get_cart(self, user):
        """获取或创建当前用户的购物车"""
        cart, created = Cart.objects.get_or_create(user=user)
        return cart

    @action(detail=False, methods=['get'])
    def my_cart(self, request):
        """获取当前用户的购物车（包含所有条目和总价）"""
        cart = self.get_cart(request.user)
        serializer = CartSerializer(cart)
        return Response(serializer.data)

    @action(detail=False, methods=['post'])
    def add(self, request):
        """添加商品到购物车（如果已存在，则增加数量）"""
        serializer = AddToCartSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        product_id = serializer.validated_data['product_id']
        quantity = serializer.validated_data.get('quantity', 1)

        product = get_object_or_404(Product, pk=product_id)
        cart = self.get_cart(request.user)

        # 查找购物车中是否已经有该商品
        cart_item, created = CartItem.objects.get_or_create(
            cart=cart,
            product=product,
            defaults={'quantity': quantity}
        )
        if not created:
            # 如果已存在，则增加数量
            cart_item.quantity += quantity
            cart_item.save()

        # 返回更新后的购物车
        serializer = CartSerializer(cart)
        return Response(serializer.data, status=status.HTTP_200_OK)

    @action(detail=False, methods=['delete'])
    def remove(self, request):
        """从购物车中移除指定商品（完全删除该条目）"""
        product_id = request.data.get('product_id')
        if not product_id:
            return Response({'error': 'product_id is required'}, status=status.HTTP_400_BAD_REQUEST)

        cart = self.get_cart(request.user)
        deleted_count, _ = CartItem.objects.filter(cart=cart, product_id=product_id).delete()
        if deleted_count == 0:
            return Response({'error': 'Product not found in cart'}, status=status.HTTP_404_NOT_FOUND)

        # 返回更新后的购物车
        serializer = CartSerializer(cart)
        return Response(serializer.data)

    @action(detail=False, methods=['patch'])
    def update_quantity(self, request):
        """更新购物车中某个商品的数量（新数量必须 >= 1，若为0则删除）"""
        product_id = request.data.get('product_id')
        new_quantity = request.data.get('quantity')

        if not product_id or new_quantity is None:
            return Response({'error': 'product_id and quantity are required'}, status=status.HTTP_400_BAD_REQUEST)

        try:
            new_quantity = int(new_quantity)
            if new_quantity < 0:
                raise ValueError
        except ValueError:
            return Response({'error': 'quantity must be a non-negative integer'}, status=status.HTTP_400_BAD_REQUEST)

        cart = self.get_cart(request.user)
        cart_item = get_object_or_404(CartItem, cart=cart, product_id=product_id)

        if new_quantity == 0:
            cart_item.delete()
        else:
            cart_item.quantity = new_quantity
            cart_item.save()

        serializer = CartSerializer(cart)
        return Response(serializer.data)