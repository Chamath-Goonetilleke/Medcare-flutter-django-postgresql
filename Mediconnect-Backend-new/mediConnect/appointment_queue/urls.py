from django.urls import path
from . import views

urlpatterns = [
    path('appointment-queues/', views.get_all_appointment_queues),
    path('appointment-queues/create/', views.create_appointment_queue),  # Place this before the date path
    path('appointment-queues/<int:pk>/', views.get_appointment_queue_by_id),
    path('appointment-queues/update/<int:pk>/', views.update_appointment_queue),
    path('appointment-queues/delete/<int:pk>/', views.delete_appointment_queue),
    path('appointment-queues/getUniqueQueue/', views.get_appointment_queue_by_date),
]
