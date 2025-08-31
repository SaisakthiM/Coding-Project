from django.contrib import admin
from django.urls import include, path
import blog

urlpatterns = [
    path('admin/', admin.site.urls),
    path('blog/', include('blog/urls.py'))
]
