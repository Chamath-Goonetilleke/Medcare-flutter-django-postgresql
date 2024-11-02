from django.db import models

from hospital.models import Hospital
from user.models import User


class Doctor(models.Model):
    User_ID = models.OneToOneField(User, on_delete=models.CASCADE, unique=True)
    Doctor_ID = models.BigAutoField(primary_key=True)

    First_name = models.CharField(max_length=255)
    Last_name = models.CharField(max_length=255)
    Other_name = models.CharField(max_length=255)
    Birthday = models.CharField(max_length=255)

    Street_No = models.CharField(max_length=255)
    Street_Name = models.CharField(max_length=255)
    City = models.CharField(max_length=255)
    Postal_Code = models.CharField(max_length=255)

    NIC = models.CharField(max_length=20)
    Specialization = models.CharField(max_length=255)

    Reg_num = models.CharField()
    Specialization = models.CharField(max_length=255)
    Rating = models.FloatField(default=0.0)
    Current_HOS_ID = models.ForeignKey(Hospital, on_delete=models.CASCADE, null=True)
    Availability = models.BooleanField(default=True)
    ID_photo = models.BigIntegerField(null=True)
