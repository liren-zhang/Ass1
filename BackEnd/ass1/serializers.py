# BackEnd/ass1/serializers.py

from rest_framework import serializers
from .models import Product, Cart, CartItem

# Product serializer
class ProductSerializer(serializers.ModelSerializer):
    class Meta:
        model = Product
        fields = ['id', 'name', 'price', 'description', 'image', 'stock', 'created_at']
        read_only_fields = ['id', 'created_at']


# Cart item serializer (nested inside cart)
class CartItemSerializer(serializers.ModelSerializer):
    product = ProductSerializer(read_only=True)
    total_price = serializers.SerializerMethodField()

    class Meta:
        model = CartItem
        fields = ['id', 'product', 'quantity', 'total_price']
        read_only_fields = ['id']

    def get_total_price(self, obj):
        return obj.total_price()


# Cart serializer (includes items and total)
class CartSerializer(serializers.ModelSerializer):
    items = CartItemSerializer(many=True, read_only=True)
    total_price = serializers.SerializerMethodField()
    username = serializers.CharField(source='user.username', read_only=True)

    class Meta:
        model = Cart
        fields = ['id', 'username', 'items', 'total_price', 'created_at', 'updated_at']
        read_only_fields = ['id', 'created_at', 'updated_at']

    def get_total_price(self, obj):
        return obj.total_price()


# Custom serializer for adding to cart (not directly mapped to a model)
class AddToCartSerializer(serializers.Serializer):
    product_id = serializers.IntegerField(min_value=1)
    quantity = serializers.IntegerField(min_value=1, default=1)