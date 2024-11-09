from django.db import models

from doctor.models import Doctor


class Task(models.Model):
    doctor_id = models.ForeignKey(Doctor, on_delete=models.CASCADE)
    name = models.CharField(max_length=100)
    venue = models.CharField(max_length=100)
    date = models.DateField()
    start_time = models.TimeField()
    end_time = models.TimeField()
    is_completed = models.BooleanField(default=False)

    def __str__(self):
        return f"{self.name} at {self.venue} on {self.date}"
