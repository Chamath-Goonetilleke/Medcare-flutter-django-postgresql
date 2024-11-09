from django.urls import path
from . import views

urlpatterns = [
    path('tasks/getByDoc/<int:doc_id>', views.get_tasks, name='get_tasks'),
    path('tasks/create/', views.create_task, name='create_task'),
    path('tasks/<int:pk>/update/', views.update_task, name='update_task'),
]
