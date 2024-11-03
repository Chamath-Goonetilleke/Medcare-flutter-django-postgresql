# urls.py
from django.urls import path
from . import views

urlpatterns = [
    path('prescriptions/create/', views.create_prescription),
    path('prescriptions/', views.get_all_prescriptions),
    path('prescriptions/doctor/<int:doctor_id>/', views.get_prescriptions_by_doctor_id),
    path('prescriptions/patient/<int:patient_id>/', views.get_prescriptions_by_patient_id),
    path('prescriptions/<int:pk>/', views.get_prescription_by_id),
    path('prescriptions/update/<int:pk>/', views.update_prescription),
    path('prescriptions/delete/<int:pk>/', views.delete_prescription),
]
