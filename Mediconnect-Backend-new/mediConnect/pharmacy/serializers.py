from rest_framework import serializers

from medicine.models import Medicine
from .models import Pharmacy


class MedicineSerializer(serializers.ModelSerializer):
    class Meta:
        model = Medicine
        fields = '__all__'


class PharmacySerializer(serializers.ModelSerializer):
    Medicine_ID = MedicineSerializer()

    class Meta:
        model = Pharmacy
        fields = '__all__'


class PharmacyAddSerializer(serializers.ModelSerializer):
    class Meta:
        model = Pharmacy
        fields = '__all__'
