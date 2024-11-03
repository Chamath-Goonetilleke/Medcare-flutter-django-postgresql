# urls.py
from django.urls import path
from . import views

urlpatterns = [
    path('appointments/', views.get_all_appointments),
    path('appointments/create/', views.create_appointment),
    path('appointments/<int:pk>/', views.get_appointment_by_id),
    path('appointments/getByQueue/<int:queue_id>/', views.get_all_appointments_by_queue_id),
    path('appointments/getFilteredQueue/<int:queue_id>/', views.get_all_filtered_appointments_by_queue_id),
    path('appointments/<int:pk>/update/', views.update_appointment),
    path('appointments/<int:pk>/delete/', views.delete_appointment),
]
