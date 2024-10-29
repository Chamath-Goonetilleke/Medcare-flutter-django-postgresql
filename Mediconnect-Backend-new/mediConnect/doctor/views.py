from django.shortcuts import get_object_or_404
from rest_framework.response import Response
from rest_framework import status
from rest_framework.decorators import api_view

from doctor_visit_hospital.models import DoctorVisitHospital
from doctor_visit_hospital.serializers import DoctorVisitHospitalSerializer
from hospital.models import Hospital
from hospital.serializers import HospitalSerializer
from user.models import User
from .models import Doctor
from .serializers import DoctorSerializer


# Create a new doctor
@api_view(['POST'])
def create_doctor(request):
    data = request.data

    # Check if the user associated with this doctor already exists
    if not User.objects.filter(User_ID=data['User_ID']).exists():
        return Response({"status": "error", "message": "User not found"}, status=status.HTTP_404_NOT_FOUND)

    # Check if a doctor already exists for this user
    if Doctor.objects.filter(User_ID=data['User_ID']).exists():
        return Response({"status": "error", "message": "Doctor already exists for this user"},
                        status=status.HTTP_400_BAD_REQUEST)

    # Create a new doctor
    doctor = Doctor.objects.create(
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
        Specialization=data['Specialization'],
        Reg_num=data['Reg_num'],
        Rating=0.0,
        Current_HOS=data.get('Current_HOS', None),
        Availability=data.get('Availability', True),
        ID_photo=data.get('ID_photo', None)
    )

    # Serialize and return the response
    serializer = DoctorSerializer(doctor)
    return Response({"status": "success", "data": serializer.data, "message": "Doctor created successfully"},
                    status=status.HTTP_201_CREATED)


# Get a doctor by ID
@api_view(['GET'])
def get_doctor_by_id(request, pk):
    try:
        doctor = Doctor.objects.get(Doctor_ID=pk)
        serializer = DoctorSerializer(doctor, many=False)
        return Response({"status": "success", "data": serializer.data}, status=status.HTTP_200_OK)
    except Doctor.DoesNotExist:
        return Response({"status": "error", "message": "Doctor not found"}, status=status.HTTP_404_NOT_FOUND)


# Get all doctors
@api_view(['GET'])
def get_all_doctors(request):
    doctors = Doctor.objects.all()
    serializer = DoctorSerializer(doctors, many=True)
    return Response({"status": "success", "data": serializer.data}, status=status.HTTP_200_OK)


@api_view(['GET'])
def get_doctor_with_visit(request, pk):
    doctor = Doctor.objects.get(Doctor_ID=pk)
    visits = DoctorVisitHospital.objects.filter(Doctor_ID=pk)
    d_serializer = DoctorSerializer(doctor, many=False)
    v_serializer = DoctorVisitHospitalSerializer(visits, many=True)

    return Response({"status": "success", "data": {"doctor": d_serializer.data, 'visits': v_serializer.data}},
                    status=status.HTTP_200_OK)


# Update a doctor
@api_view(['PATCH'])
def update_doctor(request, pk):
    try:
        doctor = Doctor.objects.get(Doctor_ID=pk)
    except Doctor.DoesNotExist:
        return Response({"status": "error", "message": "Doctor not found"}, status=status.HTTP_404_NOT_FOUND)

    data = request.data
    serializer = DoctorSerializer(instance=doctor, data=data, partial=True)  # Use partial=True for partial updates

    if serializer.is_valid():
        serializer.save()
        return Response({"status": "success", "data": serializer.data}, status=status.HTTP_200_OK)

    return Response({"status": "error", "message": serializer.errors}, status=status.HTTP_400_BAD_REQUEST)


# Delete a doctor
@api_view(['DELETE'])
def delete_doctor(request, pk):
    try:
        doctor = Doctor.objects.get(Doctor_ID=pk)
        doctor.delete()
        return Response({"status": "success", "message": "Doctor deleted successfully"},
                        status=status.HTTP_204_NO_CONTENT)
    except Doctor.DoesNotExist:
        return Response({"status": "error", "message": "Doctor not found"}, status=status.HTTP_404_NOT_FOUND)
