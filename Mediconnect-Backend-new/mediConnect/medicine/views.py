from rest_framework.response import Response
from rest_framework import status
from rest_framework.decorators import api_view
from .models import Medicine
from .serializers import MedicineSerializer, MedicineAddSerializer


# Create a new medicine entry
@api_view(['POST'])
def create_medicine(request):
    serializer = MedicineAddSerializer(data=request.data, many=True)
    if serializer.is_valid():
        serializer.save()
        return Response({"status": "success", "data": serializer.data}, status=status.HTTP_201_CREATED)
    return Response({"status": "error", "message": serializer.errors}, status=status.HTTP_400_BAD_REQUEST)


# Get all medicines
@api_view(['GET'])
def get_all_medicines(request):
    medicines = Medicine.objects.all()
    serializer = MedicineSerializer(medicines, many=True)
    return Response({"status": "success", "data": serializer.data}, status=status.HTTP_200_OK)


# Get all medicines by prescription ID
@api_view(['GET'])
def get_medicines_by_prescription_id(request, prescription_id):
    medicines = Medicine.objects.filter(Prescription_ID=prescription_id)
    serializer = MedicineSerializer(medicines, many=True)
    return Response({"status": "success", "data": serializer.data, "total": len(medicines)}, status=status.HTTP_200_OK)


# Get a medicine by ID
@api_view(['GET'])
def get_medicine_by_id(request, pk):
    try:
        medicine = Medicine.objects.get(Medicine_ID=pk)
        serializer = MedicineSerializer(medicine)
        return Response({"status": "success", "data": serializer.data}, status=status.HTTP_200_OK)
    except Medicine.DoesNotExist:
        return Response({"status": "error", "message": "Medicine not found"}, status=status.HTTP_404_NOT_FOUND)


# Update a medicine
@api_view(['PUT'])
def update_medicine(request, pk):
    try:
        medicine = Medicine.objects.get(Medicine_ID=pk)
    except Medicine.DoesNotExist:
        return Response({"status": "error", "message": "Medicine not found"}, status=status.HTTP_404_NOT_FOUND)

    serializer = MedicineSerializer(instance=medicine, data=request.data, partial=True)
    if serializer.is_valid():
        serializer.save()
        return Response({"status": "success", "data": serializer.data}, status=status.HTTP_200_OK)
    return Response({"status": "error", "message": serializer.errors}, status=status.HTTP_400_BAD_REQUEST)


# Delete a medicine
@api_view(['DELETE'])
def delete_medicine(request, pk):
    try:
        medicine = Medicine.objects.get(Medicine_ID=pk)
        medicine.delete()
        return Response({"status": "success", "message": "Medicine deleted successfully"},
                        status=status.HTTP_204_NO_CONTENT)
    except Medicine.DoesNotExist:
        return Response({"status": "error", "message": "Medicine not found"}, status=status.HTTP_404_NOT_FOUND)
