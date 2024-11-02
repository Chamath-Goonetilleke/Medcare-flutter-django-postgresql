from rest_framework import serializers

from appointment_queue.models import AppointmentQueue
from patient.models import Patient
from .models import Appointment
from doctor.models import Doctor
from hospital.models import Hospital


class DoctorSerializer(serializers.ModelSerializer):
    class Meta:
        model = Doctor
        fields = '__all__'  # Add or customize fields as necessary


class HospitalSerializer(serializers.ModelSerializer):
    class Meta:
        model = Hospital
        fields = '__all__'  # Add or customize fields as necessary


class AppointmentQueueSerializer(serializers.ModelSerializer):
    class Meta:
        model = AppointmentQueue
        fields = '__all__'


class PatientSerializer(serializers.ModelSerializer):
    class Meta:
        model = Patient
        fields = '__all__'


class AppointmentSerializer(serializers.ModelSerializer):
    Doctor_ID = DoctorSerializer()
    Hospital_ID = HospitalSerializer()
    Queue_ID = AppointmentQueueSerializer()
    Patient_ID = PatientSerializer()

    class Meta:
        model = Appointment
        fields = '__all__'


class AppointmentAddSerializer(serializers.ModelSerializer):
    class Meta:
        model = Appointment
        fields = '__all__'
