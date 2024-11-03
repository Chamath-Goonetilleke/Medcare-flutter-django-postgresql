from django.db import models

from prescription.models import Prescription


class Keywords(models.Model):
    Keyword_ID = models.BigAutoField(primary_key=True)
    Prescription_ID = models.ForeignKey(Prescription, on_delete=models.CASCADE)
    Keyword = models.CharField(max_length=255)
