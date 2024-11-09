from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status
from .models import Task
from .serializers import TaskSerializer, TaskAddSerializer


@api_view(['POST'])
def create_task(request):
    serializer = TaskAddSerializer(data=request.data)
    if serializer.is_valid():
        serializer.save()
        return Response({"status": "success", "data": serializer.data}, status=status.HTTP_201_CREATED)
    return Response({"status": "error", "message": serializer.errors}, status=status.HTTP_400_BAD_REQUEST)


@api_view(['GET'])
def get_tasks(request, doc_id):
    tasks = Task.objects.filter(doctor_id=doc_id)
    serializer = TaskSerializer(tasks, many=True)
    return Response({"status": "success", "data": serializer.data}, status=status.HTTP_200_OK)


@api_view(['PUT'])
def update_task(request, pk):
    try:
        task = Task.objects.get(id=pk)
    except Task.DoesNotExist:
        return Response({"status": "error", "message": "Task not found"}, status=status.HTTP_404_NOT_FOUND)

    serializer = TaskSerializer(instance=task, data=request.data, partial=True)
    if serializer.is_valid():
        serializer.save()
        return Response({"status": "success", "data": serializer.data}, status=status.HTTP_200_OK)
    return Response({"status": "error", "message": serializer.errors}, status=status.HTTP_400_BAD_REQUEST)
