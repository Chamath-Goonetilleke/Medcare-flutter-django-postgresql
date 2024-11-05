# serializers.py
from rest_framework import serializers

from medicine.models import Medicine
from pharmacy.models import Pharmacy
from .models import Reminder


class MedicineSerializer(serializers.ModelSerializer):
    class Meta:
        model = Medicine
        fields = '__all__'


class ReminderSerializer(serializers.ModelSerializer):
    Medicine_ID = MedicineSerializer()

    class Meta:
        model = Reminder
        fields = '__all__'


class ReminderAddSerializer(serializers.ModelSerializer):
    class Meta:
        model = Reminder
        fields = '__all__'
