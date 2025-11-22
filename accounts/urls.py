# accounts/urls.py
from django.urls import path
from django.contrib.auth import views as auth_views
from . import views # Import our own views

urlpatterns = [
    path('register/', views.register, name='register'),

    # --- THIS LINE IS CHANGED ---
    # We now point to our own custom view, not auth_views.LoginView
    path('login/', views.login_view, name='login'),

    path('logout/', auth_views.LogoutView.as_view(
        next_page='home'
    ), name='logout'),
]