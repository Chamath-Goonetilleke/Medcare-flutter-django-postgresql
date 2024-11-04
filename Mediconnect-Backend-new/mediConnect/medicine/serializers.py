from rest_framework import serializers

from medicine.models import Medicine
from prescription.models import Prescription


class PrescriptionSerializer(serializers.ModelSerializer):
    class Meta:
        model = Prescription
        fields = '__all__'


class MedicineSerializer(serializers.ModelSerializer):
    Prescription_ID = PrescriptionSerializer()
    class Meta:
        model = Medicine
        fields = '__all__'


class MedicineAddSerializer(serializers.ModelSerializer):
    class Meta:
        model = Medicine
        fields = '__all__'
