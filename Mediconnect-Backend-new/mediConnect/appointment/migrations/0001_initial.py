# Generated by Django 5.1.1 on 2024-11-04 14:21

import django.db.models.deletion
from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        ('appointment_queue', '0001_initial'),
        ('doctor', '0001_initial'),
        ('hospital', '0001_initial'),
        ('patient', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='Appointment',
            fields=[
                ('Appointment_ID', models.BigAutoField(primary_key=True, serialize=False)),
                ('Token_no', models.BigIntegerField()),
                ('Start_time', models.CharField()),
                ('End_time', models.CharField()),
                ('Status', models.CharField(default='Queued', max_length=255)),
                ('Date', models.CharField()),
                ('Approx_Time', models.CharField()),
                ('Disease', models.CharField(max_length=255)),
                ('Doctor_ID', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='doctor.doctor')),
                ('Hospital_ID', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='hospital.hospital')),
                ('Patient_ID', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='patient.patient')),
                ('Queue_ID', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='appointment_queue.appointmentqueue')),
            ],
        ),
    ]
