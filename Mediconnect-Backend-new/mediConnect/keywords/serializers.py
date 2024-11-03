from rest_framework import serializers

from keywords.models import Keywords
from prescription.models import Prescription


class PrescriptionSerializer(serializers.ModelSerializer):
    class Meta:
        model = Prescription
        fields = '__all__'


class KeywordsSerializer(serializers.ModelSerializer):
    Prescription_ID = PrescriptionSerializer()

    class Meta:
        model = Keywords
        fields = '__all__'


class KeywordsAddSerializer(serializers.ModelSerializer):
    class Meta:
        model = Keywords
        fields = '__all__'
