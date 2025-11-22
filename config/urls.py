from django.contrib import admin
from django.urls import path, include
from django.conf import settings
from django.conf.urls.static import static

urlpatterns = [
    path('admin/', admin.site.urls),

    # Store App
    path('', include('store.urls')),

    # Accounts App (Login/Register)
    path('accounts/', include('accounts.urls')),
]

# --- THE FIX: Add Browser Reload URLs ---
# This handles the auto-refresh logic.
if settings.DEBUG:
    urlpatterns += [
        path("__reload__/", include("django_browser_reload.urls")),
    ]

    # Serve media files in development
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)