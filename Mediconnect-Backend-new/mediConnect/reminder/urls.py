# urls.py
from django.urls import path
from . import views

urlpatterns = [
    path('reminder/create', views.create_reminder, name='create_reminder'),
    path('reminders/daily/<int:med_id>', views.get_daily_reminders, name='get_daily_reminders'),
    path('reminder/mark_completed/<int:pk>/', views.mark_reminder_completed, name='mark_reminder_completed'),
]
