import json
import razorpay
import uuid  # <--- ADDED THIS IMPORT
from decimal import Decimal
from django.conf import settings
from django.shortcuts import render, get_object_or_404, redirect
from django.contrib import messages
from django.db.models import Sum, Min
from django.views.decorators.http import require_POST
from django.views.decorators.csrf import csrf_exempt
from django.contrib.auth.decorators import login_required
from django.http import HttpResponseBadRequest
from django.contrib.admin.views.decorators import staff_member_required

# ... (Keep your imports for Email, Models, Forms etc.) ...
from django.core.mail import send_mail
from django.template.loader import render_to_string
from django.utils.html import strip_tags
from .models import Product, Category, ProductVariant, CartItem, Order, OrderItem, Size, Color
from .forms import OrderForm


# ---------------------------------------------------------
# 1. HOME & CATEGORY PAGES
# ---------------------------------------------------------

def home(request):
    # Only get products where is_featured is True
    products = Product.objects.filter(is_featured=True).annotate(
        total_stock=Sum('variants__stock'),
        min_price=Min('variants__price')
    )
    context = {
        'products': products,
    }
    return render(request, 'store/home.html', context)


def category_detail(request, category_slug):
    category = get_object_or_404(Category, slug=category_slug)

    # 1. Start with all products in this category
    products = Product.objects.filter(category=category)

    # 2. Get Filter Parameters from URL
    min_price = request.GET.get('min_price')
    max_price = request.GET.get('max_price')
    selected_size = request.GET.get('size')
    selected_color = request.GET.get('color')

    # 3. Apply Filters
    if min_price:
        products = products.filter(variants__price__gte=min_price)

    if max_price:
        products = products.filter(variants__price__lte=max_price)

    if selected_size:
        products = products.filter(variants__size__name=selected_size)

    if selected_color:
        products = products.filter(variants__color__name=selected_color)

    # 4. Remove duplicates
    products = products.distinct()

    # 5. Annotate for display (Price & Stock)
    products = products.annotate(
        total_stock=Sum('variants__stock'),
        min_price=Min('variants__price')
    )

    # 6. Get data for the Filter Sidebar options
    all_sizes = Size.objects.all()
    all_colors = Color.objects.all()

    context = {
        'category': category,
        'products': products,
        'all_sizes': all_sizes,
        'all_colors': all_colors,
        'selected_min_price': min_price,
        'selected_max_price': max_price,
        'selected_size': selected_size,
        'selected_color': selected_color,
    }
    return render(request, 'store/category_detail.html', context)


# ---------------------------------------------------------
# 2. PRODUCT DETAIL & SEARCH
# ---------------------------------------------------------

def product_detail(request, product_slug):
    product = get_object_or_404(Product, slug=product_slug)
    images = product.images.all()

    # Get all variants for this product
    variants = product.variants.all()

    # Create simple lists of available colors and sizes for the buttons
    available_colors = list(set(v.color for v in variants if v.color))
    available_sizes = list(set(v.size for v in variants if v.size))

    # Build the JSON data for JavaScript to handle clicks
    variants_data = []
    for v in variants:
        variants_data.append({
            'id': v.id,
            'size__name': v.size.name if v.size else None,
            'color__name': v.color.name if v.color else None,
            'price': str(v.price),  # Convert Decimal to string for JSON
            'stock': v.stock
        })

    # --- NEW: RELATED PRODUCTS LOGIC ---
    # 1. Get products in same category
    # 2. Exclude the current product
    # 3. Annotate with price/stock
    # 4. Order randomly ('?') and take 4
    related_products = Product.objects.filter(category=product.category).exclude(id=product.id).annotate(
        total_stock=Sum('variants__stock'),
        min_price=Min('variants__price')
    ).order_by('?')[:4]

    context = {
        'product': product,
        'images': images,
        'available_colors': available_colors,
        'available_sizes': available_sizes,
        'variants_data_json': json.dumps(variants_data),
        'related_products': related_products,  # Pass to template
    }
    return render(request, 'store/product_detail.html', context)


def product_search(request):
    query = request.GET.get('q')

    if query:
        # Case-insensitive exact match for product code
        product = Product.objects.filter(product_code__iexact=query).first()

        if product:
            return redirect('product_detail', product_slug=product.slug)

        # Also search by name (Optional improvement for better search)
        products = Product.objects.filter(name__icontains=query)
        if products.exists():
            # If we found multiple by name, maybe show them in category_detail?
            # For now, let's just redirect to the first one to keep it simple
            return redirect('product_detail', product_slug=products.first().slug)

    messages.error(request, f"Sorry, no product found for '{query}'.")
    return redirect('home')


# ---------------------------------------------------------
# 3. CART FUNCTIONALITY
# ---------------------------------------------------------

@require_POST
def add_to_cart(request):
    try:
        variant_id = request.POST.get('variant_id')
        quantity = int(request.POST.get('quantity', 1))

        # CHECK WHICH BUTTON WAS CLICKED
        action = request.POST.get('action', 'add_to_cart')  # Default to 'add_to_cart'

        if not variant_id:
            messages.error(request, "Please select a size and color.")
            return redirect(request.META.get('HTTP_REFERER', 'home'))

        variant = get_object_or_404(ProductVariant, id=variant_id)

        if quantity > variant.stock:
            messages.warning(request, f"Sorry, only {variant.stock} items are in stock.")
            return redirect('product_detail', product_slug=variant.product.slug)

        # --- HYBRID LOGIC START ---

        if request.user.is_authenticated:
            # LOGGED IN USER: Save to Database
            cart_item, created = CartItem.objects.get_or_create(
                user=request.user,
                variant=variant
            )
            if not created:
                cart_item.quantity += quantity
                cart_item.save()
            else:
                cart_item.quantity = quantity
                cart_item.save()
        else:
            # GUEST USER: Save to Session
            cart = request.session.get('cart', {})
            variant_id_str = str(variant.id)

            if variant_id_str in cart:
                cart[variant_id_str] += quantity
            else:
                cart[variant_id_str] = quantity

            request.session['cart'] = cart

        # --- HYBRID LOGIC END ---

        # --- REDIRECT LOGIC (THE NEW PART) ---
        if action == 'buy_now':
            return redirect('checkout')
        else:
            messages.success(request, f"Added {variant.product.name} to cart.")
            return redirect('product_detail', product_slug=variant.product.slug)

    except Exception as e:
        messages.error(request, f"Error: {str(e)}")
        return redirect(request.META.get('HTTP_REFERER', 'home'))


def cart_detail(request):
    cart_items = []
    total_cart_price = Decimal('0.00')

    if request.user.is_authenticated:
        # LOGGED IN: Fetch from Database
        db_items = CartItem.objects.filter(user=request.user).select_related('variant__product', 'variant__size',
                                                                             'variant__color')

        for item in db_items:
            subtotal = item.variant.price * item.quantity
            total_cart_price += subtotal

            # Structure it to match the template
            cart_items.append({
                'variant_id': item.variant.id,
                'product_name': item.variant.product.name,
                'thumbnail': item.variant.product.thumbnail,
                'size': item.variant.size,
                'color': item.variant.color,
                'quantity': item.quantity,
                'price': item.variant.price,
                'subtotal': subtotal,
                'slug': item.variant.product.slug
            })

    else:
        # GUEST: Fetch from Session
        cart = request.session.get('cart', {})
        variant_ids = cart.keys()
        variants = ProductVariant.objects.filter(id__in=variant_ids).select_related('product', 'size', 'color')

        for variant in variants:
            quantity = cart[str(variant.id)]
            subtotal = variant.price * quantity
            total_cart_price += subtotal

            cart_items.append({
                'variant_id': variant.id,
                'product_name': variant.product.name,
                'thumbnail': variant.product.thumbnail,
                'size': variant.size,
                'color': variant.color,
                'quantity': quantity,
                'price': variant.price,
                'subtotal': subtotal,
                'slug': variant.product.slug
            })

    context = {
        'cart_items': cart_items,
        'total_cart_price': total_cart_price,
    }
    return render(request, 'store/cart_detail.html', context)


def remove_from_cart(request, variant_id):
    if request.user.is_authenticated:
        # Remove from Database
        CartItem.objects.filter(user=request.user, variant_id=variant_id).delete()
    else:
        # Remove from Session
        cart = request.session.get('cart', {})
        variant_id_str = str(variant_id)
        if variant_id_str in cart:
            del cart[variant_id_str]
            request.session['cart'] = cart

    messages.success(request, "Item removed.")

    # --- NEW REDIRECT LOGIC ---
    # Check where the user clicked the button from
    referer = request.META.get('HTTP_REFERER')

    # If they were on the Checkout page, send them back to Checkout
    if referer and 'checkout' in referer:
        return redirect('checkout')

    # Otherwise, go back to the Cart page (default behavior)
    return redirect('cart_detail')

# ---------------------------------------------------------
# 4. CHECKOUT
# ---------------------------------------------------------

@login_required
def checkout(request):
    # --- 1. NEW: Merge Session Cart to Database Cart ---
    # When a guest logs in and lands here, we move their session items to the DB
    session_cart = request.session.get('cart', {})

    if session_cart:
        for variant_id_str, quantity in session_cart.items():
            try:
                variant_id = int(variant_id_str)
                variant = ProductVariant.objects.get(id=variant_id)

                # Get or Create the item in the user's DB cart
                cart_item, created = CartItem.objects.get_or_create(
                    user=request.user,
                    variant=variant
                )

                if created:
                    cart_item.quantity = int(quantity)
                else:
                    # If item already exists in DB, add the session quantity to it
                    cart_item.quantity += int(quantity)

                # Ensure we don't exceed stock
                if cart_item.quantity > variant.stock:
                    cart_item.quantity = variant.stock

                cart_item.save()
            except ProductVariant.DoesNotExist:
                continue

        # Clear the session cart now that it's saved to DB
        request.session['cart'] = {}
        request.session.modified = True
    # ---------------------------------------------------

    # 2. Get Cart Items (Now fetching the merged items)
    cart_items = CartItem.objects.filter(user=request.user)
    count = cart_items.count()

    if count <= 0:
        messages.warning(request, "Your cart is empty.")
        return redirect('home')

    # 3. Calculate Total
    total = Decimal('0.00')
    for item in cart_items:
        total += (item.variant.price * item.quantity)

    # 4. Handle Form Submission
    if request.method == 'POST':
        form = OrderForm(request.POST)
        if form.is_valid():
            data = form.save(commit=False)
            data.user = request.user
            data.order_total = total
            data.ip = request.META.get('REMOTE_ADDR')
            data.save()

            # Generate Order Number
            import datetime
            yr = int(datetime.date.today().strftime('%Y'))
            dt = int(datetime.date.today().strftime('%d'))
            mt = int(datetime.date.today().strftime('%m'))
            d = datetime.date(yr, mt, dt)
            current_date = d.strftime("%Y%m%d")
            order_number = current_date + str(data.id)
            data.order_id = order_number
            data.save()

            # Move Cart Items to Order Items
            for item in cart_items:
                order_item = OrderItem()
                order_item.order = data
                order_item.variant = item.variant
                order_item.price = item.variant.price
                order_item.quantity = item.quantity
                order_item.save()

            return redirect('payment', order_id=data.order_id)
    else:
        # Pre-fill form with user data if available (Optional User Profile logic could go here)
        initial_data = {
            'first_name': request.user.first_name,
            'last_name': request.user.last_name,
            'email': request.user.email
        }
        form = OrderForm(initial=initial_data)

    context = {
        'form': form,
        'cart_items': cart_items,
        'total': total,
    }
    return render(request, 'store/checkout.html', context)

# ---------------------------------------------------------
# 5. PAYMENT & ORDER MANAGEMENT
# ---------------------------------------------------------

@login_required
def payment(request, order_id):
    order = get_object_or_404(Order, order_id=order_id, user=request.user)

    razorpay_order_id = None
    amount_in_paise = int(order.order_total * 100)

    # --- LOGIC: SIMULATION VS REAL ---
    if settings.PAYMENT_SIMULATION_MODE:
        # SIMULATION: Generate a fake internal ID
        # We do NOT contact Razorpay servers
        fake_order_id = f"order_sim_{uuid.uuid4().hex[:10]}"
        order.razorpay_order_id = fake_order_id
        order.save()
        razorpay_order_id = fake_order_id
    else:
        # REAL: Contact Razorpay Servers
        try:
            client = razorpay.Client(auth=(settings.RAZORPAY_KEY_ID, settings.RAZORPAY_KEY_SECRET))
            razorpay_order = client.order.create({
                "amount": amount_in_paise,
                "currency": "INR",
                "payment_capture": "1"
            })
            order.razorpay_order_id = razorpay_order['id']
            order.save()
            razorpay_order_id = razorpay_order['id']
        except Exception as e:
            messages.error(request, "Error connecting to Payment Gateway. Please try again.")
            return redirect('checkout')

    context = {
        'order': order,
        'razorpay_order_id': razorpay_order_id,
        'razorpay_merchant_key': settings.RAZORPAY_KEY_ID,
        'razorpay_amount': amount_in_paise,
        'currency': 'INR',
        'callback_url': request.build_absolute_uri('/payment/callback/'),
        'is_simulation': settings.PAYMENT_SIMULATION_MODE,  # Pass switch to template
    }
    return render(request, 'store/payment.html', context)


@csrf_exempt
def callback(request):
    # Helper function to handle success logic (Stock, Cart, Email)
    def finalize_order(order, payment_id):
        # 1. Mark Paid
        order.is_ordered = True
        order.status = 'Accepted'
        order.payment_id = payment_id
        order.save()

        # 2. Reduce Stock
        order_items = OrderItem.objects.filter(order=order)
        for item in order_items:
            variant = item.variant
            variant.stock -= item.quantity
            variant.save()

        # 3. Clear Cart
        CartItem.objects.filter(user=order.user).delete()

        # 4. Send Emails (Customer)
        subject_user = f"Order Confirmed! #{order.order_id}"
        email_from = settings.EMAIL_HOST_USER
        recipient_list_user = [order.email, ]
        html_message_user = render_to_string('store/emails/order_confirmed.html', {'order': order})
        plain_message_user = strip_tags(html_message_user)
        try:
            send_mail(subject_user, plain_message_user, email_from, recipient_list_user, html_message=html_message_user)
        except Exception:
            pass  # Fail silently

        # 5. Send Emails (Admin)
        from django.urls import reverse
        subject_admin = f"🔔 New Order: #{order.order_id} from {order.first_name}"
        admin_url = request.build_absolute_uri(reverse('admin:store_order_change', args=[order.id]))
        context_admin = {'order': order, 'admin_url': admin_url}
        html_message_admin = render_to_string('store/emails/admin_new_order.html', context_admin)
        plain_message_admin = strip_tags(html_message_admin)
        recipient_list_admin = [settings.EMAIL_HOST_USER, ]
        try:
            send_mail(subject_admin, plain_message_admin, email_from, recipient_list_admin,
                      html_message=html_message_admin)
        except Exception:
            pass

        return render(request, 'store/success.html', {'order': order})

    # --- MAIN CALLBACK HANDLER ---
    if request.method == "POST":
        try:
            payment_id = request.POST.get('razorpay_payment_id', '')
            razorpay_order_id = request.POST.get('razorpay_order_id', '')
            signature = request.POST.get('razorpay_signature', '')

            # CHECK: SIMULATION MODE
            if settings.PAYMENT_SIMULATION_MODE:
                # In simulation, we check for our specific "success" signature
                if signature == 'simulated_success':
                    try:
                        order = Order.objects.get(razorpay_order_id=razorpay_order_id)
                        # Generate a fake payment ID for DB
                        if not payment_id or payment_id == 'pay_simulated_123456':
                            payment_id = f"pay_sim_{uuid.uuid4().hex[:10]}"
                        return finalize_order(order, payment_id)
                    except Order.DoesNotExist:
                        return HttpResponseBadRequest("Order Not Found")

            # CHECK: REAL MODE
            else:
                client = razorpay.Client(auth=(settings.RAZORPAY_KEY_ID, settings.RAZORPAY_KEY_SECRET))
                params_dict = {
                    'razorpay_order_id': razorpay_order_id,
                    'razorpay_payment_id': payment_id,
                    'razorpay_signature': signature
                }

                try:
                    client.utility.verify_payment_signature(params_dict)
                    order = Order.objects.get(razorpay_order_id=razorpay_order_id)
                    return finalize_order(order, payment_id)
                except razorpay.errors.SignatureVerificationError:
                    return render(request, 'store/failure.html')
                except Order.DoesNotExist:
                    return HttpResponseBadRequest("Order Not Found")

        except Exception as e:
            print(f"Error: {e}")
            return render(request, 'store/failure.html')

    return HttpResponseBadRequest()


@login_required
def my_orders(request):
    orders = Order.objects.filter(user=request.user).order_by('-created_at')
    context = {
        'orders': orders
    }
    return render(request, 'store/my_orders.html', context)


# --- INVOICE VIEW ---
@staff_member_required
def admin_order_invoice(request, order_id):
    order = get_object_or_404(Order, id=order_id)
    return render(request, 'store/admin_invoice.html', {'order': order})