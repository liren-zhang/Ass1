# BackEnd/ass1/models.py

from django.db import models
from django.contrib.auth.models import User

# Product model
class Product(models.Model):
    name = models.CharField(max_length=200, verbose_name="Product Name")
    price = models.DecimalField(max_digits=10, decimal_places=2, verbose_name="Unit Price")
    description = models.TextField(blank=True, verbose_name="Description")
    image = models.ImageField(upload_to='products/', blank=True, null=True, verbose_name="Product Image")
    stock = models.PositiveIntegerField(default=0, verbose_name="Stock Quantity")
    created_at = models.DateTimeField(auto_now_add=True, verbose_name="Created At")

    def __str__(self):
        return self.name

    class Meta:
        verbose_name = "Product"
        verbose_name_plural = "Products"


# Cart model – one per user
class Cart(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name='cart', verbose_name="User")
    created_at = models.DateTimeField(auto_now_add=True, verbose_name="Created At")
    updated_at = models.DateTimeField(auto_now=True, verbose_name="Updated At")

    def __str__(self):
        return f"{self.user.username}'s Cart"

    class Meta:
        verbose_name = "Shopping Cart"
        verbose_name_plural = "Shopping Carts"

    def total_price(self):
        return sum(item.total_price() for item in self.items.all())


# Cart item model – links cart and product with quantity
class CartItem(models.Model):
    cart = models.ForeignKey(Cart, on_delete=models.CASCADE, related_name='items', verbose_name="Cart")
    product = models.ForeignKey(Product, on_delete=models.CASCADE, verbose_name="Product")
    quantity = models.PositiveIntegerField(default=1, verbose_name="Quantity")

    def __str__(self):
        return f"{self.product.name} x {self.quantity}"

    class Meta:
        verbose_name = "Cart Item"
        verbose_name_plural = "Cart Items"
        unique_together = ('cart', 'product')

    def total_price(self):
        return self.product.price * self.quantity