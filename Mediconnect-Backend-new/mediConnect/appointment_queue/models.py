from django.db import models

from doctor.models import Doctor
from hospital.models import Hospital


class AppointmentQueue(models.Model):
    Queue_ID = models.BigAutoField(primary_key=True)
    Doctor_ID = models.ForeignKey(Doctor, on_delete=models.CASCADE)
    Hospital_ID = models.ForeignKey(Hospital, on_delete=models.CASCADE)
    Date = models.CharField(max_length=255)

    Current_Number = models.BigIntegerField(default=1)



