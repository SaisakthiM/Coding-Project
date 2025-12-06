from django.contrib.auth.models import AbstractUser, Group, Permission
from django.db import models

class CustomUser(AbstractUser):
    profile_name = models.CharField(max_length=150, unique=True, db_index=True)
    bio = models.TextField(blank=True, null=True)
    profile_picture = models.ImageField(upload_to='profiles/', blank=True, null=True)

    # Override groups and user_permissions to avoid reverse accessor clashes
    groups = models.ManyToManyField(
        Group,
        related_name='customuser_set',  # avoids clash with auth.User
        blank=True,
        help_text='The groups this user belongs to.'
    )
    user_permissions = models.ManyToManyField(
        Permission,
        related_name='customuser_permissions_set',  # avoids clash with auth.User
        blank=True,
        help_text='Specific permissions for this user.'
    )

    def __str__(self):
        return self.username
