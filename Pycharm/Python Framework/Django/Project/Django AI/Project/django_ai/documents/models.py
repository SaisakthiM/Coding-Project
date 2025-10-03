from django.db import models
from django.conf import settings
from django.utils import timezone
# Create your models here.

User = settings.AUTH_USER_MODEL # -> auth.USER

def set_my_default_val():
    return timezone.now()
"""
There is a new thing we can learn here
we normally use like
name = models.CharField(max_length=100)
but now we can also use
name: str
that's it it creates a column name with varchar field
"""
class Document(models.Model):
    owner = models.ForeignKey(User, on_delete=models.CASCADE)
    title = models.CharField(default="Title")
    content = models.TextField(blank=True, null=True)
    active = models.BooleanField(default=True)
    active_at = models.DateTimeField(auto_now=False, auto_now_add=False, null=True,blank=True, default=timezone.now)
    created_at = models.DateTimeField(auto_now_add=True) # Database auto updates this field to when it's created
    updated_at = models.DateTimeField(auto_now_add=True) # Database auto updates this field to when it's updated

    def save(self, *args, **kwargs):
        if self.active and self.active_at is None:
            self.active_at = timezone.now()
        else:
            self.active_at = None
        super().save(*args, **kwargs)