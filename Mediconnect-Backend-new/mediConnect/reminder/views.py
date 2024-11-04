# views.py
from rest_framework.response import Response
from rest_framework import status
from rest_framework.decorators import api_view
from .models import Reminder
from .serializers import PharmacySerializer, ReminderSerializer, ReminderAddSerializer


# Reminder views
@api_view(['POST'])
def create_reminder(request):
    serializer = ReminderAddSerializer(data=request.data, many=True)
    if serializer.is_valid():
        serializer.save()
        return Response({"status": "success", "data": serializer.data}, status=status.HTTP_201_CREATED)
    return Response({"status": "error", "message": serializer.errors}, status=status.HTTP_400_BAD_REQUEST)

@api_view(['GET'])
def get_daily_reminders(request):
    reminders = Reminder.objects.all()  # Fetch active reminders
    serializer = ReminderSerializer(reminders, many=True)
    return Response({"status": "success", "data": serializer.data}, status=status.HTTP_200_OK)

@api_view(['POST'])
def mark_reminder_completed(request, pk):
    try:
        reminder = Reminder.objects.get(pk=pk)
        reminder.is_active = False
        reminder.save()
        return Response({"status": "success", "message": "Reminder marked as completed"}, status=status.HTTP_200_OK)
    except Reminder.DoesNotExist:
        return Response({"status": "error", "message": "Reminder not found"}, status=status.HTTP_404_NOT_FOUND)
