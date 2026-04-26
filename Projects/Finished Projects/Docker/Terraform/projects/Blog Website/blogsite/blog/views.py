from django.shortcuts import render, redirect, get_object_or_404
from .models import Post, Comment, Profile
from .forms import PostForm, CommentForm, RegisterForm, ProfileForm
from django.contrib.auth.decorators import login_required
from django.contrib.auth.forms import AuthenticationForm
from django.http import HttpResponseForbidden
from django.contrib.auth import login, logout


def login_view(request):
    if request.user.is_authenticated:
        return redirect('home')
    if request.method == 'POST':
        form = AuthenticationForm(request, data=request.POST)
        if form.is_valid():
            login(request, form.get_user())
            return redirect('home')
    else:
        form = AuthenticationForm()
    return render(request, 'blog/login.html', {'form': form})


def logout_view(request):
    logout(request)
    return redirect('home')


def home(request):
    posts = Post.objects.all().order_by('-created_at')
    return render(request, 'blog/home.html', {'posts': posts})


def post_detail(request, pk):
    post = get_object_or_404(Post, pk=pk)
    comments = post.comments.all()
    if request.method == 'POST':
        if not request.user.is_authenticated:
            return redirect('login')
        form = CommentForm(request.POST)
        if form.is_valid():
            comment = form.save(commit=False)
            comment.post = post
            comment.author = request.user
            comment.save()
            return redirect('post_detail', pk=post.pk)
    else:
        form = CommentForm()
    return render(request, 'blog/post_detail.html', {'post': post, 'comments': comments, 'form': form})


@login_required
def edit_post(request, pk):
    post = get_object_or_404(Post, pk=pk)
    if request.user != post.author:
        return redirect('home')
    if request.method == 'POST':
        form = PostForm(request.POST, request.FILES, instance=post)  # added request.FILES for image
        if form.is_valid():
            form.save()
            return redirect('post_detail', pk=post.pk)
    else:
        form = PostForm(instance=post)
    return render(request, 'blog/edit_post.html', {'form': form})


def register(request):
    if request.user.is_authenticated:
        return redirect('home')
    if request.method == 'POST':
        form = RegisterForm(request.POST)
        if form.is_valid():
            user = form.save()
            login(request, user)
            return redirect('home')
    else:
        form = RegisterForm()
    return render(request, 'blog/register.html', {'form': form})


@login_required
def profile(request):
    profile, created = Profile.objects.get_or_create(user=request.user)
    user_posts = Post.objects.filter(author=request.user).order_by('-created_at')
    if request.method == 'POST':
        form = ProfileForm(request.POST, request.FILES, instance=profile)
        if form.is_valid():
            form.save()
            return redirect('profile')  # redirect after save to avoid re-POST on refresh
    else:
        form = ProfileForm(instance=profile)
    return render(request, 'blog/profile.html', {'form': form, 'user_posts': user_posts})


@login_required
def create_post(request):
    if request.method == 'POST':
        form = PostForm(request.POST, request.FILES)  # added request.FILES for image upload
        if form.is_valid():
            post = form.save(commit=False)
            post.author = request.user
            post.save()
            return redirect('post_detail', pk=post.pk)  # go to the new post instead of home
    else:
        form = PostForm()
    return render(request, 'blog/create_post.html', {'form': form})


@login_required
def delete_post(request, pk):
    post = get_object_or_404(Post, pk=pk)
    if post.author != request.user:
        return HttpResponseForbidden("You are not allowed to delete this post.")
    if request.method == 'POST':
        post.delete()
        return redirect('home')
    return render(request, 'blog/delete_post.html', {'post': post})