from django import forms
from .models import Comment, BlogPost

class CommentForm(forms.ModelForm):
    class Meta:
        model = Comment
        fields = ['body']

class BlogPostForm(forms.ModelForm):
    class Meta:
        model = BlogPost
        fields = ['title', 'content']
