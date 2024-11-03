from rest_framework.response import Response
from rest_framework import status
from rest_framework.decorators import api_view
from .models import Pharmacy
from .serializers import PharmacySerializer, PharmacyAddSerializer


# Create a new pharmacy record
@api_view(['POST'])
def create_pharmacy(request):
    serializer = PharmacyAddSerializer(data=request.data)
    if serializer.is_valid():
        serializer.save()
        return Response({"status": "success", "data": serializer.data}, status=status.HTTP_201_CREATED)
    return Response({"status": "error", "message": serializer.errors}, status=status.HTTP_400_BAD_REQUEST)


# Get all pharmacy records
@api_view(['GET'])
def get_all_pharmacies(request):
    pharmacies = Pharmacy.objects.all()
    serializer = PharmacySerializer(pharmacies, many=True)
    return Response({"status": "success", "data": serializer.data}, status=status.HTTP_200_OK)


# Get a pharmacy record by ID
@api_view(['GET'])
def get_pharmacy_by_id(request, pk):
    try:
        pharmacy = Pharmacy.objects.get(pk=pk)
        serializer = PharmacySerializer(pharmacy)
        return Response({"status": "success", "data": serializer.data}, status=status.HTTP_200_OK)
    except Pharmacy.DoesNotExist:
        return Response({"status": "error", "message": "Pharmacy record not found"}, status=status.HTTP_404_NOT_FOUND)


# Update a pharmacy record
@api_view(['PUT'])
def update_pharmacy(request, pk):
    try:
        pharmacy = Pharmacy.objects.get(pk=pk)
    except Pharmacy.DoesNotExist:
        return Response({"status": "error", "message": "Pharmacy record not found"}, status=status.HTTP_404_NOT_FOUND)

    serializer = PharmacySerializer(instance=pharmacy, data=request.data, partial=True)
    if serializer.is_valid():
        serializer.save()
        return Response({"status": "success", "data": serializer.data}, status=status.HTTP_200_OK)
    return Response({"status": "error", "message": serializer.errors}, status=status.HTTP_400_BAD_REQUEST)


# Delete a pharmacy record
@api_view(['DELETE'])
def delete_pharmacy(request, pk):
    try:
        pharmacy = Pharmacy.objects.get(pk=pk)
        pharmacy.delete()
        return Response({"status": "success", "message": "Pharmacy record deleted successfully"},
                        status=status.HTTP_204_NO_CONTENT)
    except Pharmacy.DoesNotExist:
        return Response({"status": "error", "message": "Pharmacy record not found"}, status=status.HTTP_404_NOT_FOUND)
