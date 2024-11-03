from django.urls import path
from . import views

urlpatterns = [
    path('pharmacy/', views.create_pharmacy, name='create_pharmacy'),
    path('pharmacies/', views.get_all_pharmacies, name='get_all_pharmacies'),
    path('pharmacy/<int:pk>/', views.get_pharmacy_by_id, name='get_pharmacy_by_id'),
    path('pharmacy/update/<int:pk>/', views.update_pharmacy, name='update_pharmacy'),
    path('pharmacy/delete/<int:pk>/', views.delete_pharmacy, name='delete_pharmacy'),
]
