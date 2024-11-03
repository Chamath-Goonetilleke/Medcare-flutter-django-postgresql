from rest_framework import serializers

from doctor.models import Doctor
from patient.models import Patient
from prescription.models import Prescription


class DoctorSerializer(serializers.ModelSerializer):
    class Meta:
        model = Doctor
        fields = '__all__'


class PatientSerializer(serializers.ModelSerializer):
    class Meta:
        model = Patient
        fields = '__all__'


class PrescriptionSerializer(serializers.ModelSerializer):
    Patient_ID = PatientSerializer()
    Doctor_ID = DoctorSerializer()

    class Meta:
        model = Prescription
        fields = '__all__'


class PrescriptionAddSerializer(serializers.ModelSerializer):
    class Meta:
        model = Prescription
        fields = '__all__'
