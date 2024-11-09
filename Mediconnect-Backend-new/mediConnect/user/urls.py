from django.urls import path
from . import views

urlpatterns = [
    path('users/', views.get_users),
    path('users/create/', views.create_user),
    path('users/login/', views.user_login),
    path('users/<str:pk>/', views.get_user_by_id),
    path('users/currentUser/<str:pk>/', views.update_user_current_status),
    path('users/device/<str:device_id>/', views.get_user_by_device_id),
    path('users/all-device-users/<str:device_id>/', views.get_all_user_by_device_id),
    path('users/<int:pk>/update-registration/', views.update_user_registration_status),
    path('users/<int:pk>/update-role/', views.update_user_role),
]
