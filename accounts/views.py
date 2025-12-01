# accounts/views.py
from django.shortcuts import render, redirect
from django.contrib.auth import login, logout
from django.contrib.auth.forms import AuthenticationForm
from django.contrib import messages
from django.contrib.auth.models import User
from .forms import SimpleSignupForm
from store.models import ProductVariant, CartItem

# --- YOUR EXISTING MERGE FUNCTION ---
def merge_cart(request, user):
    """
    Helper function to merge Session Cart into Database Cart.
    """
    session_cart = request.session.get('cart', {})

    for variant_id, quantity in session_cart.items():
        try:
            variant = ProductVariant.objects.get(id=variant_id)
            # Check if this user already has this item in DB
            cart_item, created = CartItem.objects.get_or_create(
                user=user,
                variant=variant
            )
            if not created:
                cart_item.quantity += quantity
                cart_item.save()
            else:
                cart_item.quantity = quantity
                cart_item.save()
        except ProductVariant.DoesNotExist:
            continue

    # Clear the session cart after merging
    request.session['cart'] = {}


def login_view(request):
    next_url = request.GET.get('next', None)

    if request.method == 'POST':
        # AuthenticationForm works with our EmailBackend automatically.
        # It expects a field named 'username' in the HTML, but we will label it 'Email'.
        form = AuthenticationForm(request, data=request.POST)
        if form.is_valid():
            user = form.get_user()
            login(request, user)

            # --- MERGE SESSION TO DB ---
            merge_cart(request, user)
            # ---------------------------

            messages.success(request, f"Welcome back, {user.first_name}!")

            next_url_post = request.POST.get('next', None)
            if next_url_post:
                return redirect(next_url_post)
            return redirect('home')
    else:
        form = AuthenticationForm()

    return render(request, 'accounts/login.html', {'form': form, 'next': next_url})


def register(request):
    next_url = request.GET.get('next', None)

    if request.method == 'POST':
        form = SimpleSignupForm(request.POST)
        if form.is_valid():
            # 1. Get cleaned data
            first_name = form.cleaned_data['first_name']
            last_name = form.cleaned_data['last_name']
            email = form.cleaned_data['email']
            password = form.cleaned_data['password']

            # 2. Create User manually
            # NOTE: We use email as the username to ensure uniqueness.
            # Using first_name as username would crash if two "Johns" signed up.
            user = User.objects.create_user(
                username=email,
                email=email,
                password=password,
                first_name=first_name,
                last_name=last_name
            )

            # 3. Log the user in immediately
            # We specify the backend to ensure Django knows we logged in via Email
            login(request, user, backend='accounts.backends.EmailBackend')

            # 4. Merge Session Cart
            merge_cart(request, user)

            messages.success(request, "Account created successfully!")

            next_url_post = request.POST.get('next', None)
            if next_url_post:
                return redirect(next_url_post)
            return redirect('home')
    else:
        form = SimpleSignupForm()

    return render(request, 'accounts/register.html', {'form': form, 'next': next_url})


def logout_view(request):
    logout(request)
    messages.success(request, "You have been logged out.")
    return redirect('home')