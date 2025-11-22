from django.contrib import admin
from django.utils.html import format_html
from django.urls import reverse
from .models import (
    Category, Product, ProductImage, Size, Color,
    ProductVariant, CartItem, Order, OrderItem
)


# --- ACTIONS ---

@admin.action(description='Record Offline Sale (Reduce Stock by 1)')
def record_offline_sale(modeladmin, request, queryset):
    """
    Action to manually reduce stock for selected variants.
    Useful for tracking offline/instagram sales.
    """
    updated_count = 0
    for variant in queryset:
        if variant.stock > 0:
            variant.stock -= 1
            variant.save()
            updated_count += 1

    modeladmin.message_user(request, f"Successfully recorded offline sales for {updated_count} items.")


# --- INLINE CLASSES ---

class ProductImageInline(admin.TabularInline):
    model = ProductImage
    extra = 1


class ProductVariantInline(admin.TabularInline):
    model = ProductVariant
    extra = 1


class OrderItemInline(admin.TabularInline):
    model = OrderItem
    readonly_fields = ('variant', 'price', 'quantity', 'subtotal')
    extra = 0
    can_delete = False  # Prevent accidental deletion of history

    def subtotal(self, obj):
        # SAFETY CHECK: Only calculate if price and quantity exist.
        if obj.price and obj.quantity:
            return obj.price * obj.quantity
        return 0


# --- ADMIN CLASSES ---

class ProductAdmin(admin.ModelAdmin):
    # Updated to include 'is_featured' so admin can toggle it easily
    list_display = ('name', 'category', 'product_code', 'is_featured')

    # This allows the client to toggle the checkbox directly in the list view!
    list_editable = ('is_featured',)

    inlines = [ProductImageInline, ProductVariantInline]
    prepopulated_fields = {'slug': ('name',)}


class CategoryAdmin(admin.ModelAdmin):
    prepopulated_fields = {'slug': ('name',)}


class ProductVariantAdmin(admin.ModelAdmin):
    # This allows the client to see and edit stock directly in the list view
    list_display = ('product', 'color', 'size', 'price', 'stock')
    list_filter = ('size', 'color', 'product__category')
    search_fields = ('product__name', 'product__product_code')
    list_editable = ('stock', 'price')  # Allows editing directly in the list!
    actions = [record_offline_sale]  # Adds the "Record Offline Sale" action


class OrderAdmin(admin.ModelAdmin):
    # Added 'invoice_button' to the list_display
    list_display = ('order_id', 'full_name', 'phone', 'order_total', 'status', 'invoice_button', 'created_at')
    list_filter = ('status', 'is_ordered', 'created_at')
    search_fields = ('order_id', 'first_name', 'last_name', 'email', 'phone')
    readonly_fields = ('user', 'payment_id', 'razorpay_order_id', 'ip', 'order_total', 'created_at')
    inlines = [OrderItemInline]
    list_per_page = 20

    def full_name(self, obj):
        return f"{obj.first_name} {obj.last_name}"

    # --- NEW FUNCTION FOR INVOICE BUTTON ---
    def invoice_button(self, obj):
        # This creates the link to the invoice view
        url = reverse('admin_order_invoice', args=[obj.id])
        return format_html(
            '<a class="button" href="{}" target="_blank" style="background-color:#417690; color:white; padding:5px 10px; border-radius:4px; text-decoration:none;">Print Invoice</a>',
            url)

    invoice_button.short_description = 'Invoice'
    invoice_button.allow_tags = True


# --- REGISTRATIONS ---

admin.site.register(Size)
admin.site.register(Color)
admin.site.register(Category, CategoryAdmin)
admin.site.register(Product, ProductAdmin)
admin.site.register(ProductImage)

# Register ProductVariant with the new Admin class (Offline Sales enabled)
admin.site.register(ProductVariant, ProductVariantAdmin)

admin.site.register(CartItem)
admin.site.register(Order, OrderAdmin)
admin.site.register(OrderItem)