from django.db import models

class PageView(models.Model):
    hostname = models.CharField(max_length=32)
    timestamp = models.DateTimeField(auto_now_add=True)

class Photo(models.Model):
    name = models.CharField(max_length=40, unique=True, verbose_name="Name")
    image = models.ImageField(upload_to='photos/')
    upload_date = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.name