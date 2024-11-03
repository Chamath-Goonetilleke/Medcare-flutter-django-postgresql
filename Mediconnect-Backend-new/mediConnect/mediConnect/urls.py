from django.contrib import admin
from django.urls import path, include

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/', include('user.urls')),
    path('api/', include('patient.urls')),
    path('api/', include('hospital.urls')),
    path('api/', include('doctor_visit_hospital.urls')),
    path('api/', include('doctor.urls')),
    path('api/', include('appointment.urls')),
    path('api/', include('appointment_queue.urls')),
    path('api/', include('prescription.urls')),
    path('api/', include('medicine.urls')),
    path('api/', include('keywords.urls')),
    path('api/', include('pharmacy.urls'))
]
