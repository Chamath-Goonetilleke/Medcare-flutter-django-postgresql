from rest_framework import serializers

from doctor.models import Doctor
from patient.models import Patient
from .models import Note


# Serializer for creating a new note
class PatientSerializer(serializers.ModelSerializer):
    class Meta:
        model = Patient
        fields = '__all__'


class DoctorSerializer(serializers.ModelSerializer):
    class Meta:
        model = Doctor
        fields = '__all__'


class NoteAddSerializer(serializers.ModelSerializer):
    class Meta:
        model = Note
        fields = '__all__'


# Serializer for retrieving and displaying note information
class NoteSerializer(serializers.ModelSerializer):
    Patient_ID = PatientSerializer()
    Doctor_ID = DoctorSerializer()
    class Meta:
        model = Note
        fields = '__all__'
