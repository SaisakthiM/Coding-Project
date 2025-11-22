from django.db import models
from django.contrib.auth.models import User
from django.utils.text import slugify
from django.db.models.signals import post_save
from django.dispatch import receiver

class BlogPost(models.Model):
    title = models.CharField(max_length=200)
    slug = models.SlugField(unique=True, blank=True)
    author = models.ForeignKey(User, on_delete=models.CASCADE)
    date = models.DateTimeField(auto_now_add=True)
    content = models.TextField()

    def save(self, *args, **kwargs):
        if not self.slug:
            self.slug = slugify(self.title)
        super().save(*args, **kwargs)

class Comment(models.Model):
    post = models.ForeignKey(BlogPost, on_delete=models.CASCADE, related_name='comments')
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    body = models.TextField()
    date = models.DateTimeField(auto_now_add=True)

class Profile(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    avatar = models.ImageField(upload_to='avatars/', default='avatars/default.png')
    bio = models.TextField(blank=True)

    def __str__(self):
        return f"{self.user.username}'s Profile"

@receiver(post_save, sender=User)
def create_or_update_user_profile(sender, instance, created, **kwargs):
    if created:
        Profile.objects.create(user=instance)
    instance.profile.save()
