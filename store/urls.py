from django.urls import path
from . import views

urlpatterns = [
    path('', views.home, name='home'),
    path('category/<slug:category_slug>/', views.category_detail, name='category_detail'),
    path('product/<slug:product_slug>/', views.product_detail, name='product_detail'),
    path('search/', views.product_search, name='product_search'),
    path('add-to-cart/', views.add_to_cart, name='add_to_cart'),
    path('cart/', views.cart_detail, name='cart_detail'),
    path('cart/remove/<int:variant_id>/', views.remove_from_cart, name='remove_from_cart'),
    path('checkout/', views.checkout, name='checkout'),
    path('payment/callback/', views.callback, name='callback'),
    path('payment/<str:order_id>/', views.payment, name='payment'),
    path('my-orders/', views.my_orders, name='my_orders'),

    # --- THE FIX IS HERE ---
    # We changed the path from 'admin/invoice/...' to 'print-invoice/...'
    path('print-invoice/<int:order_id>/', views.admin_order_invoice, name='admin_order_invoice'),
]