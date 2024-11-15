# Generated by Django 5.1.1 on 2024-11-04 14:21

import django.db.models.deletion
from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        ('doctor', '0001_initial'),
        ('patient', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='Prescription',
            fields=[
                ('Prescription_ID', models.BigAutoField(primary_key=True, serialize=False)),
                ('Date', models.CharField()),
                ('Progress', models.CharField(default='0%', max_length=50)),
                ('IsHide', models.BooleanField(default=False)),
                ('Doctor_ID', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='doctor.doctor')),
                ('Patient_ID', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='patient.patient')),
            ],
        ),
    ]
