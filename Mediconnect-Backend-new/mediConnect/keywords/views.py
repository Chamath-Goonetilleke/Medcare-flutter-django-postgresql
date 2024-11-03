from rest_framework.response import Response
from rest_framework import status
from rest_framework.decorators import api_view
from .models import Keywords
from .serializers import KeywordsSerializer, KeywordsAddSerializer


# Create a new keyword
@api_view(['POST'])
def create_keyword(request):
    serializer = KeywordsAddSerializer(data=request.data, many=True)
    if serializer.is_valid():
        serializer.save()
        return Response({"status": "success", "data": serializer.data}, status=status.HTTP_201_CREATED)
    return Response({"status": "error", "message": serializer.errors}, status=status.HTTP_400_BAD_REQUEST)


# Get all keywords
@api_view(['GET'])
def get_all_keywords(request):
    keywords = Keywords.objects.all()
    serializer = KeywordsSerializer(keywords, many=True)
    return Response({"status": "success", "data": serializer.data}, status=status.HTTP_200_OK)


# Get all keywords by prescription ID
@api_view(['GET'])
def get_keywords_by_prescription_id(request, prescription_id):
    keywords = Keywords.objects.filter(Prescription_ID=prescription_id)
    serializer = KeywordsSerializer(keywords, many=True)
    return Response({"status": "success", "data": serializer.data, "total": len(keywords)}, status=status.HTTP_200_OK)


# Get a keyword by ID
@api_view(['GET'])
def get_keyword_by_id(request, pk):
    try:
        keyword = Keywords.objects.get(Keyword_ID=pk)
        serializer = KeywordsSerializer(keyword)
        return Response({"status": "success", "data": serializer.data}, status=status.HTTP_200_OK)
    except Keywords.DoesNotExist:
        return Response({"status": "error", "message": "Keyword not found"}, status=status.HTTP_404_NOT_FOUND)


# Update a keyword
@api_view(['PUT'])
def update_keyword(request, pk):
    try:
        keyword = Keywords.objects.get(Keyword_ID=pk)
    except Keywords.DoesNotExist:
        return Response({"status": "error", "message": "Keyword not found"}, status=status.HTTP_404_NOT_FOUND)

    serializer = KeywordsSerializer(instance=keyword, data=request.data, partial=True)
    if serializer.is_valid():
        serializer.save()
        return Response({"status": "success", "data": serializer.data}, status=status.HTTP_200_OK)
    return Response({"status": "error", "message": serializer.errors}, status=status.HTTP_400_BAD_REQUEST)


# Delete a keyword
@api_view(['DELETE'])
def delete_keyword(request, pk):
    try:
        keyword = Keywords.objects.get(Keyword_ID=pk)
        keyword.delete()
        return Response({"status": "success", "message": "Keyword deleted successfully"},
                        status=status.HTTP_204_NO_CONTENT)
    except Keywords.DoesNotExist:
        return Response({"status": "error", "message": "Keyword not found"}, status=status.HTTP_404_NOT_FOUND)
