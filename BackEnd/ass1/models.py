from django.db import models
from django.contrib.auth.models import User

# Create your models here.

# BackEnd/ass1/models.py

# 1. 商品模型
class Product(models.Model):
    """
    商品表：存储商品的基本信息
    """
    name = models.CharField(max_length=200, verbose_name="商品名称")  # 商品名，最大长度200
    price = models.DecimalField(max_digits=10, decimal_places=2, verbose_name="单价")  # 价格，最多10位数字，2位小数
    description = models.TextField(blank=True, verbose_name="商品描述")  # 商品描述，可以为空
    image = models.ImageField(upload_to='products/', blank=True, null=True, verbose_name="商品图片")  # 图片，可选
    stock = models.PositiveIntegerField(default=0, verbose_name="库存数量")  # 库存，非负整数，默认0
    created_at = models.DateTimeField(auto_now_add=True, verbose_name="创建时间")  # 自动记录创建时间

    def __str__(self):
        return self.name  # 在后台显示商品名

    class Meta:
        verbose_name = "商品"
        verbose_name_plural = "商品"  # 后台显示名称


# 2. 购物车模型（关联到用户）
class Cart(models.Model):
    """
    购物车表：每个用户只有一个购物车（OneToOneField）
    如果想支持未登录用户的购物车，可以改用 session_key，这里简化处理，关联到 Django 内置 User
    """
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name='cart', verbose_name="用户")
    created_at = models.DateTimeField(auto_now_add=True, verbose_name="创建时间")
    updated_at = models.DateTimeField(auto_now=True, verbose_name="更新时间")  # 自动记录每次修改时间

    def __str__(self):
        return f"{self.user.username} 的购物车"

    class Meta:
        verbose_name = "购物车"
        verbose_name_plural = "购物车"

    # 辅助方法：计算购物车总金额
    def total_price(self):
        total = sum(item.total_price() for item in self.items.all())
        return total


# 3. 购物车项模型（购物车中的每一个商品条目）
class CartItem(models.Model):
    """
    购物车条目表：记录某个购物车中的某个商品及其数量
    """
    cart = models.ForeignKey(Cart, on_delete=models.CASCADE, related_name='items', verbose_name="所属购物车")
    product = models.ForeignKey(Product, on_delete=models.CASCADE, verbose_name="商品")
    quantity = models.PositiveIntegerField(default=1, verbose_name="数量")

    def __str__(self):
        return f"{self.product.name} x {self.quantity}"

    class Meta:
        verbose_name = "购物车项"
        verbose_name_plural = "购物车项"
        unique_together = ('cart', 'product')  # 同一个购物车中同一商品只能有一条记录（避免重复）

    # 辅助方法：计算该条目的小计金额
    def total_price(self):
        return self.product.price * self.quantity