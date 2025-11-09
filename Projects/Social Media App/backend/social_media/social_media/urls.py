from django.http import JsonResponse
from django.urls import path, include
from django.views.decorators.csrf import csrf_exempt
from graphene_django.views import GraphQLView
from django.conf import settings

# Health check view
def health_check(request):
    return JsonResponse({"status": "healthy"}, status=200)

# Custom GraphQL view to disable Debug Toolbar
class NoDebugToolbarGraphQLView(GraphQLView):
    def dispatch(self, *args, **kwargs):
        if hasattr(self.request, "toolbar"):
            self.request.toolbar = None
        return super().dispatch(*args, **kwargs)

urlpatterns = [
    path("health/", health_check),  # Add this line
    path("admin/", admin.site.urls),
    path("api/posts/", include("apps.posts.urls")),
    path("graphql/", csrf_exempt(NoDebugToolbarGraphQLView.as_view(graphiql=True))),
    path("", include("django_prometheus.urls")),
]

if settings.DEBUG:
    try:
        import debug_toolbar
        urlpatterns = [
            path("__debug__/", include("debug_toolbar.urls")),
        ] + urlpatterns
    except ImportError:
        pass