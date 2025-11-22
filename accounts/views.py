# accounts/views.py

from django.shortcuts import render, redirect
from django.contrib.auth import login, authenticate, logout
from django.contrib.auth.forms import AuthenticationForm
from django.contrib import messages
from .forms import CustomUserCreationForm
from store.models import ProductVariant, CartItem  # Import these!


def merge_cart(request, user):
    """
    Helper function to merge Session Cart into Database Cart.
    """
    session_cart = request.session.get('cart', {})

    for variant_id, quantity in session_cart.items():
        variant = ProductVariant.objects.get(id=variant_id)

        # Check if this user already has this item in DB
        cart_item, created = CartItem.objects.get_or_create(
            user=user,
            variant=variant
        )

        if not created:
            # If it exists in DB, add the session quantity to it
            cart_item.quantity += quantity
            cart_item.save()
        else:
            # If not, set the quantity
            cart_item.quantity = quantity
            cart_item.save()

    # Clear the session cart after merging (since it's now in DB)
    request.session['cart'] = {}


def login_view(request):
    next_url = request.GET.get('next', None)

    if request.method == 'POST':
        form = AuthenticationForm(request, data=request.POST)
        if form.is_valid():
            user = form.get_user()
            login(request, user)

            # --- MERGE SESSION TO DB ---
            merge_cart(request, user)
            # ---------------------------

            messages.success(request, f"Welcome back, {user.username}!")

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
        form = CustomUserCreationForm(request.POST)
        if form.is_valid():
            user = form.save()
            login(request, user)

            # --- MERGE SESSION TO DB ---
            merge_cart(request, user)
            # ---------------------------

            messages.success(request, "Account created!")

            next_url_post = request.POST.get('next', None)
            if next_url_post:
                return redirect(next_url_post)
            return redirect('home')
    else:
        form = CustomUserCreationForm()

    return render(request, 'accounts/register.html', {'form': form, 'next': next_url})


# ... (logout_view remains the same) ...


def logout_view(request):
    logout(request)
    messages.success(request, "You have been logged out.")
    return redirect('home')