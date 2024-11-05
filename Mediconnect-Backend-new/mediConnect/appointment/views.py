# views.py
from rest_framework.response import Response
from rest_framework import status
from rest_framework.decorators import api_view
from .models import Appointment
from .serializers import AppointmentSerializer, AppointmentAddSerializer


# Create a new appointment
@api_view(['POST'])
def create_appointment(request):
    serializer = AppointmentAddSerializer(data=request.data)
    if serializer.is_valid():
        serializer.save()
        return Response({"status": "success", "data": serializer.data}, status=status.HTTP_201_CREATED)
    return Response({"status": "error", "message": serializer.errors}, status=status.HTTP_400_BAD_REQUEST)


# Get all appointments
@api_view(['GET'])
def get_all_appointments(request):
    appointments = Appointment.objects.all()
    serializer = AppointmentSerializer(appointments, many=True)
    return Response({"status": "success", "data": serializer.data}, status=status.HTTP_200_OK)


@api_view(['GET'])
def get_all_appointments_by_queue_id(request, queue_id):
    appointments = Appointment.objects.filter(Queue_ID=queue_id)
    serializer = AppointmentSerializer(appointments, many=True)
    return Response({"status": "success", "data": serializer.data, "queue_length": len(appointments)},
                    status=status.HTTP_200_OK)


@api_view(['GET'])
def get_all_filtered_appointments_by_queue_id(request, queue_id):
    appointments = Appointment.objects.filter(Queue_ID=queue_id, Status="Queued")
    serializer = AppointmentSerializer(appointments, many=True)
    return Response({"status": "success", "data": serializer.data, "queue_length": len(appointments)},
                    status=status.HTTP_200_OK)


# Get an appointment by IDr
@api_view(['GET'])
def get_appointment_by_id(request, pk):
    try:
        appointment = Appointment.objects.get(Appointment_ID=pk)
        serializer = AppointmentSerializer(appointment)
        return Response({"status": "success", "data": serializer.data}, status=status.HTTP_200_OK)
    except Appointment.DoesNotExist:
        return Response({"status": "error", "message": "Appointment not found"}, status=status.HTTP_404_NOT_FOUND)


# Update an appointment
@api_view(['PUT'])
def update_appointment(request, pk):
    try:
        appointment = Appointment.objects.get(Appointment_ID=pk)
    except Appointment.DoesNotExist:
        return Response({"status": "error", "message": "Appointment not found"}, status=status.HTTP_404_NOT_FOUND)

    serializer = AppointmentAddSerializer(instance=appointment, data=request.data, partial=True)
    if serializer.is_valid():
        serializer.save()
        return Response({"status": "success", "data": serializer.data}, status=status.HTTP_200_OK)
    return Response({"status": "error", "message": serializer.errors}, status=status.HTTP_400_BAD_REQUEST)


# Delete an appointment
@api_view(['DELETE'])
def delete_appointment(request, pk):
    try:
        appointment = Appointment.objects.get(Appointment_ID=pk)
        appointment.delete()
        return Response({"status": "success", "message": "Appointment deleted successfully"},
                        status=status.HTTP_200_OK)
    except Appointment.DoesNotExist:
        return Response({"status": "error", "message": "Appointment not found"}, status=status.HTTP_404_NOT_FOUND)
