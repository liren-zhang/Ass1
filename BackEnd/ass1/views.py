from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from django.shortcuts import get_object_or_404
from .models import Product, Cart, CartItem
from .serializers import ProductSerializer, CartSerializer, CartItemSerializer, AddToCartSerializer
from django.contrib.auth.models import User

# Views for Product and Cart

# Product ViewSet – full CRUD
class ProductViewSet(viewsets.ModelViewSet):
    """
    Product API endpoints:
    - GET /products/          -> list all products
    - POST /products/         -> create new product
    - GET /products/{id}/     -> retrieve single product
    - PUT /products/{id}/     -> full update
    - PATCH /products/{id}/   -> partial update
    - DELETE /products/{id}/  -> delete product
    """
    queryset = Product.objects.all()
    serializer_class = ProductSerializer
    # permission_classes = [IsAuthenticated]   # optional, commented for dev


# Cart ViewSet – custom actions only
class CartViewSet(viewsets.GenericViewSet):
    serializer_class = CartSerializer
    """
    Cart API endpoints (require ?user_id=xxx query param):
    - GET /cart/my_cart/           -> get current user's cart
    - POST /cart/add/              -> add product to cart
    - DELETE /cart/remove/         -> remove product from cart
    - PATCH /cart/update_quantity/ -> update item quantity
    """
    # permission_classes = [IsAuthenticated]   # commented for dev

    def _get_user(self, request):
        """Get user from query param 'user_id', default to admin (id=1)."""
        user_id = request.query_params.get('user_id', 1)
        try:
            user = User.objects.get(pk=user_id)
        except User.DoesNotExist:
            user = User.objects.get(pk=1)  # fallback to admin
        return user

    def get_cart(self, user):
        """Get or create a cart for the given user."""
        cart, created = Cart.objects.get_or_create(user=user)
        return cart

    @action(detail=False, methods=['get'])
    def my_cart(self, request):
        """Return current user's cart with items and total price."""
        user = self._get_user(request)
        cart = self.get_cart(user)
        serializer = CartSerializer(cart)
        return Response(serializer.data)

    @action(detail=False, methods=['post'])
    def add(self, request):
        """Add product to cart. Increase quantity if already exists."""
        user = self._get_user(request)
        serializer = AddToCartSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        product_id = serializer.validated_data['product_id']
        quantity = serializer.validated_data.get('quantity', 1)

        product = get_object_or_404(Product, pk=product_id)
        cart = self.get_cart(user)

        cart_item, created = CartItem.objects.get_or_create(
            cart=cart,
            product=product,
            defaults={'quantity': quantity}
        )
        if not created:
            cart_item.quantity += quantity
            cart_item.save()

        serializer = CartSerializer(cart)
        return Response(serializer.data, status=status.HTTP_200_OK)

    @action(detail=False, methods=['delete'])
    def remove(self, request):
        """Remove a product completely from cart."""
        user = self._get_user(request)
        product_id = request.data.get('product_id')
        if not product_id:
            return Response({'error': 'product_id is required'}, status=status.HTTP_400_BAD_REQUEST)

        cart = self.get_cart(user)
        deleted_count, _ = CartItem.objects.filter(cart=cart, product_id=product_id).delete()
        if deleted_count == 0:
            return Response({'error': 'Product not found in cart'}, status=status.HTTP_404_NOT_FOUND)

        serializer = CartSerializer(cart)
        return Response(serializer.data)

    @action(detail=False, methods=['patch'])
    def update_quantity(self, request):
        """Update quantity of a product in cart. If quantity=0, remove it."""
        user = self._get_user(request)
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

        cart = self.get_cart(user)
        cart_item = get_object_or_404(CartItem, cart=cart, product_id=product_id)

        if new_quantity == 0:
            cart_item.delete()
        else:
            cart_item.quantity = new_quantity
            cart_item.save()

        serializer = CartSerializer(cart)
        return Response(serializer.data)