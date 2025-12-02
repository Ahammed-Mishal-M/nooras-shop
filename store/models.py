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

# --- NEW IMPORTS FOR IMAGE COMPRESSION ---
from PIL import Image, ImageOps
from io import BytesIO
from django.core.files import File
import os

# --- NEW ADDITION FOR HEIC SUPPORT ---
import pillow_heif
pillow_heif.register_heif_opener()

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


def compress_image(image, filename):
    """
    Compresses an image to WebP format, resizes it if too large,
    and returns a Django-friendly File object.
    """
    im = Image.open(image)

    # 1. Handle Orientation (Fix rotation for iPhone photos)
    im = ImageOps.exif_transpose(im)

    # 2. Convert to RGB (Required for WebP/JPEG)
    if im.mode in ('RGBA', 'P'):
        im = im.convert('RGB')

    # 3. Resize if too large (Max width 1200px is enough for e-commerce)
    max_width = 1200
    if im.width > max_width:
        # Calculate new height to keep aspect ratio
        ratio = max_width / float(im.width)
        new_height = int((float(im.height) * float(ratio)))
        im = im.resize((max_width, new_height), Image.Resampling.LANCZOS)

    # 4. Save to BytesIO buffer as WebP
    im_io = BytesIO()
    # quality=85 is the sweet spot for e-commerce (sharp but small)
    im.save(im_io, format='WEBP', quality=85, optimize=True)

    # 5. Create a new filename with .webp extension
    new_filename = os.path.splitext(filename)[0] + '.webp'

    # 6. Return Django File object
    new_image = File(im_io, name=new_filename)
    return new_image


class Product(models.Model):
    category = models.ForeignKey(Category, related_name='products', on_delete=models.SET_NULL, null=True, blank=True)
    name = models.CharField(max_length=200)
    slug = models.SlugField(max_length=200, unique=True, blank=True, null=True)
    is_featured = models.BooleanField(default=False,
                                      help_text="Check this to display this product in the 'Featured Collection' on the Homepage.")
    product_code = models.CharField(
        max_length=50,
        unique=True,
        blank=True,
        null=True,
        help_text="A unique code for this product (e.g., N-1001)"
    )
    description = models.TextField(blank=True, null=True)

    # Updated Thumbnail Field
    thumbnail = models.ImageField(upload_to='product_thumbnails/', blank=True, null=True,
                                  help_text="This is the main image shown on product cards.")

    def __str__(self):
        return self.name

    def save(self, *args, **kwargs):
        if not self.slug:
            self.slug = slugify(self.name)
        if not self.product_code:
            self.product_code = f"N-{uuid.uuid4().hex[:6].upper()}"

        # --- COMPRESSION LOGIC ---
        if self.thumbnail:
            # Check if this is a new upload (no pk) or the file has changed
            try:
                # Get old instance to compare
                this = Product.objects.get(id=self.id)
                if this.thumbnail != self.thumbnail:
                    # File changed, compress the new one
                    self.thumbnail = compress_image(self.thumbnail, self.thumbnail.name)
            except Product.DoesNotExist:
                # New product, compress immediately
                self.thumbnail = compress_image(self.thumbnail, self.thumbnail.name)

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

    def save(self, *args, **kwargs):
        # --- COMPRESSION LOGIC ---
        if self.image:
            try:
                this = ProductImage.objects.get(id=self.id)
                if this.image != self.image:
                    self.image = compress_image(self.image, self.image.name)
            except ProductImage.DoesNotExist:
                self.image = compress_image(self.image, self.image.name)

        super().save(*args, **kwargs)


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