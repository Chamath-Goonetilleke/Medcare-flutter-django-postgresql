from rest_framework import serializers

from hospital.models import Hospital
from .models import Doctor


class HospitalSerializer(serializers.ModelSerializer):
    class Meta:
        model = Hospital
        fields = '__all__'  # Add or customize fields as necessary


class DoctorSerializer(serializers.ModelSerializer):
    Current_HOS_ID = HospitalSerializer()

    class Meta:
        model = Doctor
        fields = '__all__'


class DoctorAddSerializer(serializers.ModelSerializer):
    class Meta:
        model = Doctor
        fields = '__all__'
