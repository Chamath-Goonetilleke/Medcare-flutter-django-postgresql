from django.urls import path
from . import views

urlpatterns = [
    path('notes/', views.get_all_notes, name='get_all_notes'),
    path('notes/create/', views.create_note, name='create_note'),
    path('notes/<int:pk>/', views.get_note_by_id, name='get_note_by_id'),
    path('notes/patient/<int:patient_id>/', views.get_notes_by_patient_id, name='get_notes_by_patient_id'),
    path('notes/doctor/<int:patient_id>/', views.get_notes_by_doctor_id),
    path('notes/update/<int:pk>/', views.update_note, name='update_note'),
    path('notes/delete/<int:pk>/', views.delete_note, name='delete_note'),
]
