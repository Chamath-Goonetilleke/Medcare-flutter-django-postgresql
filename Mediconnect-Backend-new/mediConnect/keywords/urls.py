from django.urls import path
from . import views

urlpatterns = [
    path('keywords/create/', views.create_keyword),
    path('keywords/', views.get_all_keywords),
    path('keywords/prescription/<int:prescription_id>/', views.get_keywords_by_prescription_id),
    path('keywords/<int:pk>/', views.get_keyword_by_id),
    path('keywords/update/<int:pk>/', views.update_keyword),
    path('keywords/delete/<int:pk>/', views.delete_keyword),
]
