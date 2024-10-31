from .models import User
from .serializers import UserSerializer
from rest_framework.response import Response
from rest_framework import status
from rest_framework.decorators import api_view
from django.contrib.auth.hashers import make_password, check_password
from django.http import JsonResponse


@api_view(['GET'])
def get_users(request):
    users = User.objects.all()
    serializer = UserSerializer(users, many=True)
    return Response({"status": "success", "data": serializer.data}, status=status.HTTP_200_OK)


@api_view(['POST'])
def user_login(request):
    data = request.data
    try:
        # Check if the user exists by email
        user = User.objects.get(Email=data['Email'])

        # Check if the provided password matches the stored hashed password
        if check_password(data['Password'], user.Password):
            serializer = UserSerializer(user)
            return Response({"status": "success", "data": serializer.data}, status=status.HTTP_200_OK)
        else:
            return Response({"status": "error", "message": "Invalid password"}, status=status.HTTP_400_BAD_REQUEST)
    except User.DoesNotExist:
        return Response({"status": "error", "message": "User not found"}, status=status.HTTP_404_NOT_FOUND)


@api_view(['POST'])
def create_user(request):
    data = request.data

    # Check if a user with the same email already exists
    if User.objects.filter(Email=data['Email']).exists():
        return Response({"status": "error", "message": "Email already exists"}, status=status.HTTP_400_BAD_REQUEST)

    # Encrypt the password before saving
    hashed_password = make_password(data['Password'])

    # Create the new user
    # User.objects.create(
    #     User_ID=data['User_ID'],
    #     Email=data['Email'],
    #     Password=hashed_password,
    #     Device_ID=data['Device_ID'],
    # )
    serializer = UserSerializer(data=data)

    if serializer.is_valid():
        User.objects.create(
            User_ID=data['User_ID'],
            Email=data['Email'],
            Password=hashed_password,
            Device_ID=data['Device_ID'],
        )
        return Response({"status": "success", "data": serializer.data}, status=status.HTTP_201_CREATED)

    return Response({"status": "error", "message": "Error Creating Hospital"}, status=status.HTTP_400_BAD_REQUEST)


@api_view(['GET'])
def get_user_by_id(request, pk):
    try:
        user = User.objects.get(User_ID=pk)
        serializer = UserSerializer(user, many=False)
        return Response({"status": "success", "data": serializer.data}, status=status.HTTP_200_OK)
    except User.DoesNotExist:
        return Response({"status": "error", "message": "User not found"}, status=status.HTTP_404_NOT_FOUND)


@api_view(['PUT'])
def update_user_registration_status(request, pk):
    try:
        # Retrieve the user by their User_ID (pk)
        user = User.objects.get(User_ID=pk)
    except User.DoesNotExist:
        return Response({"status": "error", "message": "User not found"}, status=status.HTTP_404_NOT_FOUND)

    # Update the IsRegistered field to True
    user.IsRegistered = True
    user.save()

    serializer = UserSerializer(user)
    return Response(
        {"status": "success", "data": serializer.data, "message": "User registration status updated to True"},
        status=status.HTTP_200_OK)

@api_view(['PUT'])
def update_user_role(request, pk):
    try:
        # Retrieve the user by their User_ID (pk)
        user = User.objects.get(User_ID=pk)
    except User.DoesNotExist:
        return Response({"status": "error", "message": "User not found"}, status=status.HTTP_404_NOT_FOUND)

    # Update the IsRegistered field to True
    user.Role = request.data["Role"]
    user.save()

    serializer = UserSerializer(user)
    return Response(
        {"status": "success", "data": serializer.data, "message": "User registration status updated to True"},
        status=status.HTTP_200_OK)