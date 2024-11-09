from rest_framework.response import Response
from rest_framework import status
from rest_framework.decorators import api_view
from .models import Note
from .serializers import NoteSerializer, NoteAddSerializer  # Ensure these serializers are defined in serializers.py


# Create a new note
@api_view(['POST'])
def create_note(request):
    serializer = NoteAddSerializer(data=request.data)
    if serializer.is_valid():
        serializer.save()
        return Response({"status": "success", "data": serializer.data}, status=status.HTTP_201_CREATED)
    return Response({"status": "error", "message": serializer.errors}, status=status.HTTP_400_BAD_REQUEST)


# Get all notes
@api_view(['GET'])
def get_all_notes(request):
    notes = Note.objects.all()
    serializer = NoteSerializer(notes, many=True)
    return Response({"status": "success", "data": serializer.data}, status=status.HTTP_200_OK)


# Get all notes by patient ID
@api_view(['GET'])
def get_notes_by_patient_id(request, patient_id):
    notes = Note.objects.filter(Patient_ID=patient_id)
    serializer = NoteSerializer(notes, many=True)
    return Response({"status": "success", "data": serializer.data, "total": len(notes)}, status=status.HTTP_200_OK)

@api_view(['GET'])
def get_notes_by_doctor_id(request, patient_id):
    notes = Note.objects.filter(Doctor_ID=patient_id)
    serializer = NoteSerializer(notes, many=True)
    return Response({"status": "success", "data": serializer.data, "total": len(notes)}, status=status.HTTP_200_OK)


# Get a note by ID
@api_view(['GET'])
def get_note_by_id(request, pk):
    try:
        note = Note.objects.get(Notification_ID=pk)
        serializer = NoteSerializer(note)
        return Response({"status": "success", "data": serializer.data}, status=status.HTTP_200_OK)
    except Note.DoesNotExist:
        return Response({"status": "error", "message": "Note not found"}, status=status.HTTP_404_NOT_FOUND)


# Update a note
@api_view(['PUT'])
def update_note(request, pk):
    try:
        note = Note.objects.get(Notification_ID=pk)
    except Note.DoesNotExist:
        return Response({"status": "error", "message": "Note not found"}, status=status.HTTP_404_NOT_FOUND)

    serializer = NoteSerializer(instance=note, data=request.data, partial=True)
    if serializer.is_valid():
        serializer.save()
        return Response({"status": "success", "data": serializer.data}, status=status.HTTP_200_OK)
    return Response({"status": "error", "message": serializer.errors}, status=status.HTTP_400_BAD_REQUEST)


# Delete a note
@api_view(['DELETE'])
def delete_note(request, pk):
    try:
        note = Note.objects.get(Notification_ID=pk)
        note.delete()
        return Response({"status": "success", "message": "Note deleted successfully"}, status=status.HTTP_204_NO_CONTENT)
    except Note.DoesNotExist:
        return Response({"status": "error", "message": "Note not found"}, status=status.HTTP_404_NOT_FOUND)
