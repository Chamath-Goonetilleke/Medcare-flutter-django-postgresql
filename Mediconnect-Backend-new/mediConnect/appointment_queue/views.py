from rest_framework.response import Response
from rest_framework import status
from rest_framework.decorators import api_view
from .models import AppointmentQueue
from .serializers import AppointmentQueueSerializer, AppointmentQueueAddSerializer


# Create a new appointment queue
@api_view(['POST'])
def create_appointment_queue(request):
    serializer = AppointmentQueueAddSerializer(data=request.data)
    if serializer.is_valid():
        serializer.save()
        return Response({"status": "success", "data": serializer.data}, status=status.HTTP_201_CREATED)
    return Response({"status": "error", "message": serializer.errors}, status=status.HTTP_400_BAD_REQUEST)


# Get all appointment queues
@api_view(['GET'])
def get_all_appointment_queues(request):
    appointment_queues = AppointmentQueue.objects.all()
    serializer = AppointmentQueueSerializer(appointment_queues, many=True)
    return Response({"status": "success", "data": serializer.data}, status=status.HTTP_200_OK)


# Get an appointment queue by ID
@api_view(['GET'])
def get_appointment_queue_by_id(request, pk):
    try:
        appointment_queue = AppointmentQueue.objects.get(Queue_ID=pk)
        serializer = AppointmentQueueSerializer(appointment_queue)
        return Response({"status": "success", "data": serializer.data}, status=status.HTTP_200_OK)
    except AppointmentQueue.DoesNotExist:
        return Response({"status": "error", "message": "Appointment queue not found"}, status=status.HTTP_404_NOT_FOUND)


@api_view(['POST'])
def get_appointment_queue_by_date(request):
    try:
        print(request.data)
        appointment_queue = AppointmentQueue.objects.get(Date=request.data['Date'], Doctor_ID=request.data['Doctor_ID'], Hospital_ID=request.data['Hospital_ID'])
        serializer = AppointmentQueueSerializer(appointment_queue)
        return Response({"status": "success", "data": serializer.data}, status=status.HTTP_200_OK)
    except AppointmentQueue.DoesNotExist:
        return Response({"status": "error", "message": "Appointment queue not found"}, status=status.HTTP_404_NOT_FOUND)


# Update an appointment queue
@api_view(['PUT'])
def update_appointment_queue(request, pk):
    try:
        appointment_queue = AppointmentQueue.objects.get(Queue_ID=pk)
    except AppointmentQueue.DoesNotExist:
        return Response({"status": "error", "message": "Appointment queue not found"}, status=status.HTTP_404_NOT_FOUND)

    serializer = AppointmentQueueSerializer(instance=appointment_queue, data=request.data, partial=True)
    if serializer.is_valid():
        serializer.save()
        return Response({"status": "success", "data": serializer.data}, status=status.HTTP_200_OK)
    return Response({"status": "error", "message": serializer.errors}, status=status.HTTP_400_BAD_REQUEST)


# Delete an appointment queue
@api_view(['DELETE'])
def delete_appointment_queue(request, pk):
    try:
        appointment_queue = AppointmentQueue.objects.get(Queue_ID=pk)
        appointment_queue.delete()
        return Response({"status": "success", "message": "Appointment queue deleted successfully"},
                        status=status.HTTP_204_NO_CONTENT)
    except AppointmentQueue.DoesNotExist:
        return Response({"status": "error", "message": "Appointment queue not found"}, status=status.HTTP_404_NOT_FOUND)

