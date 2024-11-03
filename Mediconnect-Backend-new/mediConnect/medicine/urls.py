from django.urls import path
from . import views

urlpatterns = [
    path('medicines/create/', views.create_medicine),
    path('medicines/', views.get_all_medicines),
    path('medicines/prescription/<int:prescription_id>/', views.get_medicines_by_prescription_id),
    path('medicines/<int:pk>/', views.get_medicine_by_id),
    path('medicines/update/<int:pk>/', views.update_medicine),
    path('medicines/delete/<int:pk>/', views.delete_medicine),
]
