"""
Django settings for config project.
"""
from pathlib import Path
import os

# Build paths inside the project like this: BASE_DIR / 'subdir'.
BASE_DIR = Path(__file__).resolve().parent.parent

# --- SMART ENVIRONMENT DETECTION ---
# Checks if we are running on PythonAnywhere by looking at the folder path
IS_PRODUCTION = '/home/noorasclothing' in str(BASE_DIR)

SECRET_KEY = 'django-insecure-lqvrkd=9*nuhyxm%kxd@j-zh@pwo)@x*o(tqf+q6mb=lw1%ji$'

# --- CONFIGURATION BLOCKS ---

if IS_PRODUCTION:
    # === LIVE SERVER SETTINGS ===
    print("--- RUNNING IN PRODUCTION MODE ---")
    DEBUG = False
    ALLOWED_HOSTS = ['noorasclothing.pythonanywhere.com']

    # Live Database (PythonAnywhere MySQL)
    DATABASES = {
        'default': {
            'ENGINE': 'django.db.backends.mysql',
            'NAME': 'noorasclothing$dress_shop_db',
            'USER': 'noorasclothing',
            'PASSWORD': 'Noora@2025#345',  # Your Live Password
            'HOST': 'noorasclothing.mysql.pythonanywhere-services.com',
            'PORT': '3306',
        }
    }

    # Live Email (Real Sending)
    EMAIL_BACKEND = 'django.core.mail.backends.smtp.EmailBackend'

    # Payment (Keep Simulation True until Client pays you)
    PAYMENT_SIMULATION_MODE = True

else:
    # === LOCAL LAPTOP SETTINGS ===
    print("--- RUNNING IN LOCAL MODE ---")
    DEBUG = True
    ALLOWED_HOSTS = ['*']

    # Local Database (HeidiSQL)
    DATABASES = {
        'default': {
            'ENGINE': 'django.db.backends.mysql',
            'NAME': 'dress_shop_db',
            'USER': 'root',
            'PASSWORD': 'root',
            'HOST': '127.0.0.1',
            'PORT': '3306',
            'OPTIONS': {
                'init_command': "SET sql_mode='STRICT_TRANS_TABLES'",
            },
        }
    }

    # Local Email (Prints to Console)
    EMAIL_BACKEND = 'django.core.mail.backends.console.EmailBackend'

    # Payment (Always Simulation locally)
    PAYMENT_SIMULATION_MODE = True


# --- APPLICATION DEFINITION ---

INSTALLED_APPS = [
    'jazzmin',
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',

    # --- ADD THESE 5 LINES FOR GOOGLE LOGIN ---
    'django.contrib.sites',
    'allauth',
    'allauth.account',
    'allauth.socialaccount',
    'allauth.socialaccount.providers.google',
    # ------------------------------------------

    'tailwind',
    'theme',
    'store',
    'accounts',
]

TAILWIND_APP_NAME = 'theme'

MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
# --- ADD THIS LINE ---
    'allauth.account.middleware.AccountMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
]

# --- AUTOMATIC PERFORMANCE FIX ---
# Only add the Reload Tool if we are LOCALLY (Not Production)
if not IS_PRODUCTION:
    INSTALLED_APPS.append('django_browser_reload')
    MIDDLEWARE.append("django_browser_reload.middleware.BrowserReloadMiddleware")
    # Path to NPM (Only needed locally)
    NPM_BIN_PATH = r"C:\Program Files\nodejs\npm.cmd"


ROOT_URLCONF = 'config.urls'

TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [os.path.join(BASE_DIR, 'store', 'templates')],
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
            ],
        },
    },
]

WSGI_APPLICATION = 'config.wsgi.application'


# --- AUTHENTICATION ---
AUTH_PASSWORD_VALIDATORS = [
    {'NAME': 'django.contrib.auth.password_validation.UserAttributeSimilarityValidator',},
    {'NAME': 'django.contrib.auth.password_validation.MinimumLengthValidator',},
    {'NAME': 'django.contrib.auth.password_validation.CommonPasswordValidator',},
    {'NAME': 'django.contrib.auth.password_validation.NumericPasswordValidator',},
]

LOGIN_REDIRECT_URL = 'home'
LOGOUT_REDIRECT_URL = 'home'

# --- INTERNATIONALIZATION ---
LANGUAGE_CODE = 'en-us'
TIME_ZONE = 'UTC'
USE_I18N = True
USE_TZ = True

# --- STATIC & MEDIA ---
STATIC_URL = 'static/'
STATIC_ROOT = os.path.join(BASE_DIR, 'staticfiles')
STATICFILES_DIRS = [os.path.join(BASE_DIR, 'static')]

MEDIA_URL = '/media/'
MEDIA_ROOT = os.path.join(BASE_DIR, 'media')

DEFAULT_AUTO_FIELD = 'django.db.models.BigAutoField'

INTERNAL_IPS = ["127.0.0.1"]

# --- RAZORPAY KEYS ---
RAZORPAY_KEY_ID = 'rzp_test_RhW4po3GhDXdsq'
RAZORPAY_KEY_SECRET = 'CJmGwBBCmke3Hvpg1XC9uhCI'

# --- EMAIL CREDENTIALS ---
EMAIL_HOST = 'smtp.gmail.com'
EMAIL_PORT = 587
EMAIL_USE_TLS = True
EMAIL_HOST_USER = 'nooras.official@gmail.com'
EMAIL_HOST_PASSWORD = 'dhjw pzko vgvg wuxh'

# --- JAZZMIN SETTINGS ---
JAZZMIN_SETTINGS = {
    "site_title": "Noora's Admin",
    "site_header": "Noora's Ladies Wear",
    "site_brand": "Noora's Admin",
    "welcome_sign": "Welcome to Noora's Dashboard",
    "copyright": "Noora's Ladies Wear",
    "search_model": ["store.Order", "store.Product"],
    "topmenu_links": [
        {"name": "Home",  "url": "admin:index", "permissions": ["auth.view_user"]},
        {"name": "View Site", "url": "home", "new_window": True},
    ],
    "order_with_respect_to": ["store.Order", "store.Product", "store.ProductVariant", "store.Category", "auth"],
    "icons": {
        "auth": "fas fa-users-cog",
        "auth.user": "fas fa-user",
        "auth.Group": "fas fa-users",
        "store.Product": "fas fa-tshirt",
        "store.Category": "fas fa-layer-group",
        "store.Order": "fas fa-shopping-bag",
        "store.CartItem": "fas fa-shopping-cart",
        "store.ProductVariant": "fas fa-boxes",
        "store.Size": "fas fa-ruler",
        "store.Color": "fas fa-palette",
        "store.ProductImage": "fas fa-images",
    },
}

JAZZMIN_UI_TWEAKS = {
    "navbar_small_text": False,
    "footer_small_text": False,
    "body_small_text": False,
    "brand_small_text": False,
    "brand_colour": "navbar-dark",
    "accent": "accent-primary",
    "navbar": "navbar-white navbar-light",
    "no_navbar_border": False,
    "navbar_fixed": False,
    "layout_boxed": False,
    "footer_fixed": False,
    "sidebar_fixed": True,
    "sidebar": "sidebar-dark-primary",
    "sidebar_nav_small_text": False,
    "theme": "default",
    "dark_mode_theme": None,
    "button_classes": {
        "primary": "btn-outline-primary",
        "secondary": "btn-outline-secondary",
        "info": "btn-info",
        "warning": "btn-warning",
        "danger": "btn-danger",
        "success": "btn-success"
    }
}

SITE_ID = 1

# --- AUTHENTICATION & GOOGLE SETTINGS ---
AUTHENTICATION_BACKENDS = [
    'django.contrib.auth.backends.ModelBackend',
    'accounts.backends.EmailBackend',             # Your new Email Login
    'allauth.account.auth_backends.AuthenticationBackend',
]

SOCIALACCOUNT_LOGIN_ON_GET = True
SOCIALACCOUNT_AUTO_SIGNUP = True
ACCOUNT_EMAIL_REQUIRED = True
ACCOUNT_USERNAME_REQUIRED = False
ACCOUNT_AUTHENTICATION_METHOD = 'email'

# --- ADD THIS LINE ---
SOCIALACCOUNT_EMAIL_VERIFICATION = "none"
# This tells Allauth: "Trust the email from Google, don't verify it again."