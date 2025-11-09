from django.contrib import admin
from django.urls import path, include
from django.views.decorators.csrf import csrf_exempt
from graphene_django.views import GraphQLView

# Custom GraphQL view to disable Debug Toolbar
class NoDebugToolbarGraphQLView(GraphQLView):
    def dispatch(self, *args, **kwargs):
        if hasattr(self.request, "toolbar"):
            self.request.toolbar = None  # disable Debug Toolbar for this request
        return super().dispatch(*args, **kwargs)

urlpatterns = [
    path("admin/", admin.site.urls),

    # Your apps
    path("api/posts/", include("apps.posts.urls")),

    # GraphQL endpoint (Debug Toolbar disabled)
    path("graphql/", csrf_exempt(NoDebugToolbarGraphQLView.as_view(graphiql=True))),

    # Debug Toolbar
    path("__debug__/", include("debug_toolbar.urls")),

    # Prometheus metrics
    path("", include("django_prometheus.urls")),
]
