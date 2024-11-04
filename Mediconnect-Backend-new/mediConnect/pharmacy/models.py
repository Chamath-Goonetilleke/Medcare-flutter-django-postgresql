from django.db import models

from medicine.models import Medicine


class Pharmacy(models.Model):
    Medicine_ID = models.OneToOneField(Medicine, on_delete=models.CASCADE, primary_key=True)
    Interval = models.CharField(max_length=255, null=True)
    Times_per_day = models.IntegerField(null=True)
    Monday = models.BooleanField(default=False)
    Tuesday = models.BooleanField(default=False)
    Wednesday = models.BooleanField(default=False)
    Thursday = models.BooleanField(default=False)
    Friday = models.BooleanField(default=False)
    Saturday = models.BooleanField(default=False)
    Sunday = models.BooleanField(default=False)
    Before_meal = models.BooleanField(default=False)
    After_meal = models.BooleanField(default=False)
    Quantity = models.CharField(max_length=255)
    Turn_off_after = models.CharField(max_length=255)
    IsReminderSet = models.BooleanField(default=False)
    Notes = models.TextField()

