from django.db import models
from django.utils.text import slugify
from django.contrib.auth.models import User
import uuid

# --- EMAIL SIGNAL IMPORTS ---
from django.db.models.signals import pre_save
from django.dispatch import receiver
from django.core.mail import send_mail
from django.conf import settings
from django.template.loader import render_to_string
from django.utils.html import strip_tags


# ... (Category model is unchanged) ...
class Category(models.Model):
    name = models.CharField(max_length=100)
    description = models.CharField(max_length=255, blank=True, null=True)
    slug = models.SlugField(max_length=100, unique=True, blank=True, null=True)

    class Meta:
        verbose_name_plural = 'Categories'

    def __str__(self):
        return self.name


class Size(models.Model):
    name = models.CharField(max_length=50, unique=True)  # e.g., "S", "M", "One Size"

    def __str__(self):
        return self.name


class Color(models.Model):
    name = models.CharField(max_length=50, unique=True)  # e.g., "Red", "Olive Green"

    def __str__(self):
        return self.name


class Product(models.Model):
    category = models.ForeignKey(Category, related_name='products', on_delete=models.SET_NULL, null=True, blank=True)
    name = models.CharField(max_length=200)
    slug = models.SlugField(max_length=200, unique=True, blank=True, null=True)
    is_featured = models.BooleanField(default=False,help_text="Check this to display this product in the 'Featured Collection' on the Homepage.")
    product_code = models.CharField(
        max_length=50,
        unique=True,
        blank=True,
        null=True,
        help_text="A unique code for this product (e.g., N-1001)"
    )
    description = models.TextField(blank=True, null=True)
    thumbnail = models.ImageField(upload_to='product_thumbnails/', blank=True, null=True,
                                  help_text="This is the main image shown on product cards.")

    def __str__(self):
        return self.name

    def save(self, *args, **kwargs):
        if not self.slug:
            self.slug = slugify(self.name)
        if not self.product_code:
            self.product_code = f"N-{uuid.uuid4().hex[:6].upper()}"
        super().save(*args, **kwargs)


class ProductVariant(models.Model):
    product = models.ForeignKey(Product, related_name='variants', on_delete=models.CASCADE)
    size = models.ForeignKey(Size, on_delete=models.SET_NULL, null=True, blank=True)
    color = models.ForeignKey(Color, on_delete=models.SET_NULL, null=True, blank=True)
    price = models.DecimalField(max_digits=10, decimal_places=2)
    stock = models.IntegerField(default=0)

    class Meta:
        unique_together = ('product', 'size', 'color')

    def __str__(self):
        return f"{self.product.name} - {self.size} / {self.color} ({self.stock} in stock)"


class ProductImage(models.Model):
    product = models.ForeignKey(Product, related_name='images', on_delete=models.CASCADE)
    image = models.ImageField(upload_to='product_gallery/')

    def __str__(self):
        return f"Image for {self.product.name}"


class CartItem(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE, null=True, blank=True)
    variant = models.ForeignKey(ProductVariant, on_delete=models.CASCADE)
    quantity = models.PositiveIntegerField(default=1)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.quantity} x {self.variant}"

    @property
    def subtotal(self):
        return self.variant.price * self.quantity


class Order(models.Model):
    STATUS_CHOICES = (
        ('Pending', 'Pending'),
        ('Accepted', 'Accepted'),
        ('Packed', 'Packed'),
        ('On The Way', 'On The Way'),
        ('Delivered', 'Delivered'),
        ('Cancelled', 'Cancelled'),
    )

    user = models.ForeignKey(User, on_delete=models.SET_NULL, null=True)

    # Billing Info
    first_name = models.CharField(max_length=50)
    last_name = models.CharField(max_length=50)
    phone = models.CharField(max_length=15)
    email = models.EmailField(max_length=50)
    address_line_1 = models.CharField(max_length=100)
    address_line_2 = models.CharField(max_length=100, blank=True)
    city = models.CharField(max_length=50)
    state = models.CharField(max_length=50)
    country = models.CharField(max_length=50, default='India')
    pin_code = models.CharField(max_length=10)

    # Order Info
    order_total = models.DecimalField(max_digits=10, decimal_places=2)
    status = models.CharField(max_length=50, choices=STATUS_CHOICES, default='Pending')
    ip = models.CharField(blank=True, max_length=20)
    is_ordered = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    # --- PAYMENT FIELDS ---
    payment_id = models.CharField(max_length=100, blank=True, null=True)
    order_id = models.CharField(max_length=100, blank=True, null=True)
    razorpay_order_id = models.CharField(max_length=100, blank=True, null=True)

    def __str__(self):
        return self.first_name


class OrderItem(models.Model):
    order = models.ForeignKey(Order, on_delete=models.CASCADE)
    variant = models.ForeignKey(ProductVariant, on_delete=models.CASCADE)
    price = models.DecimalField(max_digits=10, decimal_places=2)
    quantity = models.IntegerField()
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.variant.product.name


# --- EMAIL NOTIFICATION SIGNAL ---
# This function runs automatically BEFORE an Order is saved to the database.
@receiver(pre_save, sender=Order)
def send_status_update_email(sender, instance, **kwargs):
    if instance.pk:  # Check if this order already exists (it's an update, not new create)
        try:
            # Get the old version of the order from the database to compare
            old_order = Order.objects.get(pk=instance.pk)

            if old_order.status != instance.status:
                # Status has changed! Prepare the email.

                message_body = ""
                if instance.status == 'Packed':
                    message_body = "We have packed your items and they are ready for shipping."
                elif instance.status == 'On The Way':
                    message_body = "Your package has been shipped! It is making its way to you."
                elif instance.status == 'Delivered':
                    message_body = "Your item has been delivered. We hope you love it!"
                elif instance.status == 'Cancelled':
                    message_body = "Your order has been cancelled. Please contact us if you have questions."

                # If status is one of the above, send email
                if message_body:
                    subject = f"Update on Order #{instance.order_id}"
                    email_from = settings.EMAIL_HOST_USER
                    recipient_list = [instance.email, ]

                    # Render the HTML template
                    context = {
                        'order': instance,
                        'message_body': message_body
                    }
                    html_message = render_to_string('store/emails/status_update.html', context)
                    plain_message = strip_tags(html_message)  # Fallback

                    send_mail(subject, plain_message, email_from, recipient_list, html_message=html_message)

        except Exception as e:
            print(f"Error sending status email: {e}")