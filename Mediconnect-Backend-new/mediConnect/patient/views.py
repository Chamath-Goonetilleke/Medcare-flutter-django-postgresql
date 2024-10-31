from django.shortcuts import get_object_or_404
from rest_framework.response import Response
from rest_framework import status
from rest_framework.decorators import api_view

from user.models import User
from .models import Patient
from .serializers import PatientSerializer


# Create a new patient
@api_view(['POST'])
def create_patient(request):
    data = request.data

    # Check if the user associated with this patient already exists
    if not User.objects.filter(User_ID=data['User_ID']).exists():
        return Response({"status": "error", "message": "User not found"}, status=status.HTTP_404_NOT_FOUND)

    # Check if a patient already exists for this user
    if Patient.objects.filter(User_ID=data['User_ID']).exists():
        return Response({"status": "error", "message": "Patient already exists for this user"},
                        status=status.HTTP_400_BAD_REQUEST)

    # Create a new patient
    patient = Patient.objects.create(
        User_ID=get_object_or_404(User, User_ID=data['User_ID']),
        First_name=data['First_name'],
        Last_name=data['Last_name'],
        Other_name=data['Other_name'],
        Birthday=data['Birthday'],
        Street_No=data['Street_No'],
        Street_Name=data['Street_Name'],
        City=data['City'],
        Postal_Code=data['Postal_Code'],
        NIC=data['NIC'],
        Breakfast_time=data['Breakfast_time'],
        Lunch_time=data['Lunch_time'],
        Dinner_time=data['Dinner_time']
    )

    # Serialize and return the response
    serializer = PatientSerializer(patient)
    return Response({"status": "success", "data": serializer.data, "message": "Patient created successfully"},
                    status=status.HTTP_201_CREATED)


# Get a patient by ID
@api_view(['GET'])
def get_patient_by_id(request, pk):
    try:
        patient = Patient.objects.get(Patient_ID=pk)
        serializer = PatientSerializer(patient, many=False)
        return Response({"status": "success", "data": serializer.data}, status=status.HTTP_200_OK)
    except Patient.DoesNotExist:
        return Response({"status": "error", "message": "Patient not found"}, status=status.HTTP_404_NOT_FOUND)


@api_view(['GET'])
def get_patient_by_user_id(request, userId):
    try:
        patient = Patient.objects.get(User_ID_id=userId)
        serializer = PatientSerializer(patient, many=False)
        return Response({"status": "success", "data": serializer.data}, status=status.HTTP_200_OK)
    except Patient.DoesNotExist:
        return Response({"status": "error", "message": "Patient not found"}, status=status.HTTP_404_NOT_FOUND)


@api_view(['GET'])
def get_all_patients(request):
    hospitals = Patient.objects.all()
    serializer = PatientSerializer(hospitals, many=True)
    return Response({"status": "success", "data": serializer.data}, status=status.HTTP_200_OK)


# Update a patient
@api_view(['PUT'])
def update_patient(request, pk):
    try:
        patient = Patient.objects.get(Patient_ID=pk)
    except Patient.DoesNotExist:
        return Response({"status": "error", "message": "Patient not found"}, status=status.HTTP_404_NOT_FOUND)

    data = request.data
    serializer = PatientSerializer(instance=patient, data=data, partial=True)  # Use partial=True for partial updates

    if serializer.is_valid():
        serializer.save()
        return Response({"status": "success", "data": serializer.data}, status=status.HTTP_200_OK)

    return Response({"status": "error", "message": serializer.errors}, status=status.HTTP_400_BAD_REQUEST)


# Delete a patient
@api_view(['DELETE'])
def delete_patient(request, pk):
    try:
        patient = Patient.objects.get(Patient_ID=pk)
        patient.delete()
        return Response({"status": "success", "message": "Patient deleted successfully"},
                        status=status.HTTP_204_NO_CONTENT)
    except Patient.DoesNotExist:
        return Response({"status": "error", "message": "Patient not found"}, status=status.HTTP_404_NOT_FOUND)
