# Generated by Django 5.1.1 on 2024-11-04 14:21

import django.db.models.deletion
from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        ('prescription', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='Keywords',
            fields=[
                ('Keyword_ID', models.BigAutoField(primary_key=True, serialize=False)),
                ('Keyword', models.CharField(max_length=255)),
                ('Prescription_ID', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='prescription.prescription')),
            ],
        ),
    ]
