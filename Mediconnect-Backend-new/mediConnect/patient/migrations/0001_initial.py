# Generated by Django 5.1.1 on 2024-11-04 14:21

import django.db.models.deletion
from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        ('user', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='Patient',
            fields=[
                ('Patient_ID', models.BigAutoField(primary_key=True, serialize=False)),
                ('First_name', models.CharField(max_length=255)),
                ('Last_name', models.CharField(max_length=255)),
                ('Other_name', models.CharField(max_length=255)),
                ('Birthday', models.CharField(max_length=255)),
                ('Street_No', models.CharField(max_length=255)),
                ('Street_Name', models.CharField(max_length=255)),
                ('City', models.CharField(max_length=255)),
                ('Postal_Code', models.CharField(max_length=255)),
                ('NIC', models.CharField(max_length=20)),
                ('Breakfast_time', models.CharField(max_length=255)),
                ('Lunch_time', models.CharField(max_length=255)),
                ('Dinner_time', models.CharField(max_length=255)),
                ('User_ID', models.OneToOneField(on_delete=django.db.models.deletion.CASCADE, to='user.user')),
            ],
        ),
    ]
