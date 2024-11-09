from django.db import models

from doctor.models import Doctor
from patient.models import Patient


class Note(models.Model):
    Notification_ID = models.BigAutoField(primary_key=True)
    Patient_ID = models.ForeignKey(Patient, on_delete=models.CASCADE, null=True)
    Doctor_ID = models.ForeignKey(Doctor, on_delete=models.CASCADE, null=True)
    Date = models.CharField()
    Note = models.TextField()
