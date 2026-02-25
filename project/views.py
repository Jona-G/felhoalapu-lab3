import json
from django.shortcuts import render, redirect, get_object_or_404
from django import forms
from django.contrib.auth.decorators import login_required
from django.contrib.auth.forms import UserCreationForm
from django.contrib.auth import login
from django.core.exceptions import PermissionDenied

from .models import Photo

class PhotoForm(forms.ModelForm):
    class Meta:
        model = Photo
        fields = ['name', 'image']

def register(request):
    if request.method == 'POST':
        form = UserCreationForm(request.POST)
        if form.is_valid():
            user = form.save()
            login(request, user)
            return redirect('index')
    else:
        form = UserCreationForm()
    return render(request, 'project/register.html', {'form': form})

def index(request):
    sort_by = request.GET.get('sort', '-upload_date')
    allowed_sorts = ['name', '-name', 'upload_date', '-upload_date']
    if sort_by not in allowed_sorts:
        sort_by = '-upload_date'
        
    photos = Photo.objects.all().order_by(sort_by)
    return render(request, 'project/index.html', {'photos': photos})

def view_photo(request, photo_id):
    photo = get_object_or_404(Photo, id=photo_id)
    return render(request, 'project/view.html', {'photo': photo})

@login_required
def upload_photo(request):
    if request.method == 'POST':
        form = PhotoForm(request.POST, request.FILES)
        if form.is_valid():
            photo = form.save(commit=False)
            photo.user = request.user
            photo.save()
            return redirect('index')
    else:
        form = PhotoForm()
        
    names = list(Photo.objects.values_list('name', flat=True))
    return render(request, 'project/upload.html', {
        'form': form,
        'existing_names_json': json.dumps(names)
    })

@login_required
def delete_photo(request, photo_id):
    if request.method == 'POST':
        photo = get_object_or_404(Photo, id=photo_id)
        if photo.user != request.user:
            raise PermissionDenied("You can only delete your own photos!")
            
        photo.image.delete()
        photo.delete()
    return redirect('index')