from rest_framework import serializers
from .models import Task


class TaskSerializer(serializers.ModelSerializer):
    class Meta:
        model = Task
        fields = '__all__'


class TaskAddSerializer(serializers.ModelSerializer):
    class Meta:
        model = Task
        fields = ['doctor_id', 'name', 'venue', 'date', 'start_time', 'end_time']
