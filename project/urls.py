from django.urls import path, include
from django.conf import settings
from django.conf.urls.static import static
from django.contrib import admin

from . import views

urlpatterns = [
    path('', views.index, name='index'),
    path('upload/', views.upload_photo, name='upload'),
    path('photo/<int:photo_id>/', views.view_photo, name='view_photo'),
    path('delete/<int:photo_id>/', views.delete_photo, name='delete_photo'),
    path('admin/', admin.site.urls),
]

if settings.DEBUG:
    import debug_toolbar
    urlpatterns = [
        path('__debug__/', include(debug_toolbar.urls)),
    ] + urlpatterns + static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)