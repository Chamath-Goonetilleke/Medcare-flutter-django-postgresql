from django.db import models

from prescription.models import Prescription


class Medicine(models.Model):
    Medicine_ID = models.BigAutoField(primary_key=True)
    Prescription_ID = models.ForeignKey(Prescription, on_delete=models.CASCADE)
    Medicine = models.CharField(max_length=255)
    Quantity = models.CharField(max_length=255)
    Strength = models.CharField(max_length=255)
    Duration = models.CharField(max_length=255)
