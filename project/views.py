import json

from django.shortcuts import render, redirect, get_object_or_404
from django import forms

from .models import Photo

class PhotoForm(forms.ModelForm):
    class Meta:
        model = Photo
        fields = ['name', 'image']

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

def upload_photo(request):
    if request.method == 'POST':
        form = PhotoForm(request.POST, request.FILES)
        if form.is_valid():
            form.save()
            return redirect('index')
    else:
        form = PhotoForm()
        
    names = list(Photo.objects.values_list('name', flat=True))
        
    return render(request, 'project/upload.html', {
        'form': form,
        'existing_names_json': json.dumps(names)
    })

def delete_photo(request, photo_id):
    if request.method == 'POST':
        photo = get_object_or_404(Photo, id=photo_id)
        photo.image.delete()
        photo.delete()
    return redirect('index')