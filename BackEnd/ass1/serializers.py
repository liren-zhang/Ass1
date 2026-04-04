# BackEnd/ass1/serializers.py

from rest_framework import serializers
from .models import Product, Cart, CartItem

# 1. 商品序列化器
class ProductSerializer(serializers.ModelSerializer):
    """
    商品数据的序列化器
    用于：展示商品列表/详情、添加商品、更新商品
    """
    class Meta:
        model = Product
        fields = ['id', 'name', 'price', 'description', 'image', 'stock', 'created_at']
        # 注意：'created_at' 通常只读，不让用户修改，后面会在 View 中设置 read_only
        read_only_fields = ['id', 'created_at']  # 前端不需要提供这些字段，后端自动生成


# 2. 购物车项序列化器（用于嵌套在购物车中）
class CartItemSerializer(serializers.ModelSerializer):
    """
    购物车条目的序列化器
    包含商品详情（嵌套展示）和小计金额
    """
    # 嵌套商品信息，这样前端可以直接拿到 product 的所有字段
    product = ProductSerializer(read_only=True)
    # 小计金额是计算出来的，不是数据库字段，需要自定义
    total_price = serializers.SerializerMethodField()

    class Meta:
        model = CartItem
        fields = ['id', 'product', 'quantity', 'total_price']
        read_only_fields = ['id']

    def get_total_price(self, obj):
        """返回该条目的小计金额"""
        return obj.total_price()  # 调用模型中的 total_price 方法


# 3. 购物车序列化器（展示购物车内容 + 总金额）
class CartSerializer(serializers.ModelSerializer):
    """
    购物车的序列化器
    包含购物车中所有条目（嵌套展示）和总金额
    """
    items = CartItemSerializer(many=True, read_only=True)  # 嵌套显示所有购物车项
    total_price = serializers.SerializerMethodField()
    username = serializers.CharField(source='user.username', read_only=True)  # 显示用户名

    class Meta:
        model = Cart
        fields = ['id', 'username', 'items', 'total_price', 'created_at', 'updated_at']
        read_only_fields = ['id', 'created_at', 'updated_at']

    def get_total_price(self, obj):
        """返回购物车总金额"""
        return obj.total_price()  # 调用模型中的 total_price 方法


# 4. 添加商品到购物车时用的序列化器（接收 product_id 和 quantity）
class AddToCartSerializer(serializers.Serializer):
    """
    这不是直接对应模型，而是一个自定义序列化器，用于处理前端添加商品的请求
    接收 product_id 和 quantity，然后由 View 手动处理
    """
    product_id = serializers.IntegerField(min_value=1)
    quantity = serializers.IntegerField(min_value=1, default=1)