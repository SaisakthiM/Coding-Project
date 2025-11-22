from django.db import models


# Create your models here.

from django.db import models

class TODO(models.Model):
    name = models.CharField(max_length=100)
    task_description = models.TextField(blank=True)
    is_completed = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    due_date = models.DateField(null=True, blank=True)

    def __str__(self):
        return f"{self.name} ({'Done' if self.is_completed else 'Pending'})"

    class Meta:
        ordering = ['-created_at']
