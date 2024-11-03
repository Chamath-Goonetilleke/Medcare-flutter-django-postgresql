from django.db import models
from doctor.models import Doctor
from django.utils import timezone

from patient.models import Patient


class Prescription(models.Model):
    Prescription_ID = models.BigAutoField(primary_key=True)
    Doctor_ID = models.ForeignKey(Doctor, on_delete=models.CASCADE)
    Patient_ID = models.ForeignKey(Patient, on_delete=models.CASCADE)
    Date = models.CharField()
    Progress = models.CharField(max_length=50, default="0%")
    IsHide = models.BooleanField(default=False)
