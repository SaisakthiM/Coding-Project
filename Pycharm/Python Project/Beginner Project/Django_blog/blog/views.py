from django.shortcuts import render, get_object_or_404, redirect
from django.contrib.auth.decorators import login_required
from .models import BlogPost, Comment
from .forms import CommentForm, BlogPostForm
from django.http import HttpResponseForbidden
from django.contrib.auth.forms import UserCreationForm

def home(request):
    posts = BlogPost.objects.order_by('-date')
    return render(request, 'blog/home.html', {'posts': posts})

def post_detail(request, slug):
    post = get_object_or_404(BlogPost, slug=slug)
    comments = post.comments.order_by('-date')
    form = CommentForm(request.POST or None)
    if request.method == 'POST' and request.user.is_authenticated and form.is_valid():
        comment = form.save(commit=False)
        comment.post = post
        comment.user = request.user
        comment.save()
        return redirect('post_detail', slug=slug)
    return render(request, 'blog/post_detail.html', {'post': post, 'comments': comments, 'form': form})

@login_required
def edit_post(request, slug):
    post = get_object_or_404(BlogPost, slug=slug)
    if request.user != post.author:
        return HttpResponseForbidden()
    form = BlogPostForm(request.POST or None, instance=post)
    if form.is_valid():
        form.save()
        return redirect('post_detail', slug=slug)
    return render(request, 'blog/edit_post.html', {'form': form})

def register(request):
    if request.method == 'POST':
        form = UserCreationForm(request.POST)
        if form.is_valid():
            form.save()
            return redirect('login')
    else:
        form = UserCreationForm()
    return render(request, 'registration/register.html', {'form': form})
