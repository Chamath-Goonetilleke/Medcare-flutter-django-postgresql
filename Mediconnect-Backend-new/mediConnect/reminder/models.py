# models.py
from django.db import models

from medicine.models import Medicine
from pharmacy.models import Pharmacy


class Reminder(models.Model):
    Reminder_ID = models.BigAutoField(primary_key=True)
    Medicine_ID = models.ForeignKey(Medicine, on_delete=models.CASCADE)
    time = models.CharField(max_length=255)
    quantity = models.CharField(max_length=255)
    before_meal = models.BooleanField(default=False)
    after_meal = models.BooleanField(default=False)
    is_active = models.BooleanField(default=True)


