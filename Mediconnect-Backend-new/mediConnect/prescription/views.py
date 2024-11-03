# views.py
from rest_framework.response import Response
from rest_framework import status
from rest_framework.decorators import api_view
from .models import Prescription
from .serializers import PrescriptionSerializer, PrescriptionAddSerializer


# Create a new prescription
@api_view(['POST'])
def create_prescription(request):
    serializer = PrescriptionAddSerializer(data=request.data)
    if serializer.is_valid():
        serializer.save()
        return Response({"status": "success", "data": serializer.data}, status=status.HTTP_201_CREATED)
    return Response({"status": "error", "message": serializer.errors}, status=status.HTTP_400_BAD_REQUEST)


# Get all prescriptions
@api_view(['GET'])
def get_all_prescriptions(request):
    prescriptions = Prescription.objects.all()
    serializer = PrescriptionSerializer(prescriptions, many=True)
    return Response({"status": "success", "data": serializer.data}, status=status.HTTP_200_OK)


# Get all prescriptions by doctor ID
@api_view(['GET'])
def get_prescriptions_by_doctor_id(request, doctor_id):
    prescriptions = Prescription.objects.filter(Doctor_ID=doctor_id)
    serializer = PrescriptionSerializer(prescriptions, many=True)
    return Response({"status": "success", "data": serializer.data, "total": len(prescriptions)},
                    status=status.HTTP_200_OK)


# Get all prescriptions by patient ID
@api_view(['GET'])
def get_prescriptions_by_patient_id(request, patient_id):
    prescriptions = Prescription.objects.filter(Patient_ID=patient_id)
    serializer = PrescriptionSerializer(prescriptions, many=True)
    return Response({"status": "success", "data": serializer.data, "total": len(prescriptions)},
                    status=status.HTTP_200_OK)


# Get a prescription by ID
@api_view(['GET'])
def get_prescription_by_id(request, pk):
    try:
        prescription = Prescription.objects.get(Prescription_ID=pk)
        serializer = PrescriptionSerializer(prescription)
        return Response({"status": "success", "data": serializer.data}, status=status.HTTP_200_OK)
    except Prescription.DoesNotExist:
        return Response({"status": "error", "message": "Prescription not found"}, status=status.HTTP_404_NOT_FOUND)


# Update a prescription
@api_view(['PUT'])
def update_prescription(request, pk):
    try:
        prescription = Prescription.objects.get(Prescription_ID=pk)
    except Prescription.DoesNotExist:
        return Response({"status": "error", "message": "Prescription not found"}, status=status.HTTP_404_NOT_FOUND)

    serializer = PrescriptionSerializer(instance=prescription, data=request.data, partial=True)
    if serializer.is_valid():
        serializer.save()
        return Response({"status": "success", "data": serializer.data}, status=status.HTTP_200_OK)
    return Response({"status": "error", "message": serializer.errors}, status=status.HTTP_400_BAD_REQUEST)


# Delete a prescription
@api_view(['DELETE'])
def delete_prescription(request, pk):
    try:
        prescription = Prescription.objects.get(Prescription_ID=pk)
        prescription.delete()
        return Response({"status": "success", "message": "Prescription deleted successfully"},
                        status=status.HTTP_204_NO_CONTENT)
    except Prescription.DoesNotExist:
        return Response({"status": "error", "message": "Prescription not found"}, status=status.HTTP_404_NOT_FOUND)
