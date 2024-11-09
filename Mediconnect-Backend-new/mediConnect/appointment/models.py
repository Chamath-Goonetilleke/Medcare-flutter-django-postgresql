from django.db import models

from appointment_queue.models import AppointmentQueue
from doctor.models import Doctor
from hospital.models import Hospital
from patient.models import Patient


# Create your models here.
class Appointment(models.Model):
    Appointment_ID = models.BigAutoField(primary_key=True)
    Patient_ID = models.ForeignKey(Patient, on_delete=models.CASCADE)
    Token_no = models.BigIntegerField()
    Doctor_ID = models.ForeignKey(Doctor, on_delete=models.CASCADE)
    Start_time = models.CharField()
    End_time = models.CharField()
    Status = models.CharField(max_length=255, default="Queued")
    Date = models.CharField()
    Approx_Time = models.CharField()
    Disease = models.CharField(max_length=255)
    Hospital_ID = models.ForeignKey(Hospital, on_delete=models.CASCADE)
    Is_Rate = models.BooleanField(default=False)
    Queue_ID = models.ForeignKey(AppointmentQueue, on_delete=models.CASCADE)
