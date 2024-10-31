from rest_framework import serializers

from appointment_queue.models import AppointmentQueue
from doctor.models import Doctor
from hospital.models import Hospital


class DoctorSerializer(serializers.ModelSerializer):
    class Meta:
        model = Doctor
        fields = '__all__'  # Add or customize fields as necessary


class HospitalSerializer(serializers.ModelSerializer):
    class Meta:
        model = Hospital
        fields = '__all__'


class AppointmentQueueSerializer(serializers.ModelSerializer):
    Doctor_ID = DoctorSerializer()
    Hospital_ID = HospitalSerializer()

    class Meta:
        model = AppointmentQueue
        fields = '__all__'


class AppointmentQueueAddSerializer(serializers.ModelSerializer):
    class Meta:
        model = AppointmentQueue
        fields = '__all__'
