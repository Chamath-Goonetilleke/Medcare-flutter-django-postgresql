# Generated by Django 5.1.1 on 2024-10-02 07:19

import django.db.models.deletion
from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        ('doctor', '0001_initial'),
        ('hospital', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='DoctorVisitHospital',
            fields=[
                ('Visit_ID', models.BigAutoField(primary_key=True, serialize=False)),
                ('Mon', models.BooleanField(default=False)),
                ('Tue', models.BooleanField(default=False)),
                ('Wed', models.BooleanField(default=False)),
                ('Thu', models.BooleanField(default=False)),
                ('Fri', models.BooleanField(default=False)),
                ('Sat', models.BooleanField(default=False)),
                ('Sun', models.BooleanField(default=False)),
                ('AP_Start_Time', models.CharField(max_length=255)),
                ('AP_End_Time', models.CharField(max_length=255)),
                ('AP_Count', models.IntegerField()),
                ('APL_Start_Time', models.CharField(max_length=255)),
                ('APL_End_Time', models.CharField(max_length=255)),
                ('APL_Count', models.IntegerField()),
                ('Doctor_ID', models.OneToOneField(on_delete=django.db.models.deletion.CASCADE, to='doctor.doctor')),
                ('Hospital_ID', models.OneToOneField(on_delete=django.db.models.deletion.CASCADE, to='hospital.hospital')),
            ],
        ),
    ]
