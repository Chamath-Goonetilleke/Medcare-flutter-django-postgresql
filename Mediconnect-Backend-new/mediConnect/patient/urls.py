from django.urls import path
from . import views

urlpatterns = [
    path('patient', views.get_all_patients),
    path('patient/create/', views.create_patient),
    path('patient/<str:pk>/', views.get_patient_by_id),
    path('patient/getByUserId/<str:userId>/', views.get_patient_by_user_id),
]