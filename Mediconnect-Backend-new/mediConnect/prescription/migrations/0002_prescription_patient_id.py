# Generated by Django 5.1.1 on 2024-11-02 11:19

import django.db.models.deletion
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('patient', '0001_initial'),
        ('prescription', '0001_initial'),
    ]

    operations = [
        migrations.AddField(
            model_name='prescription',
            name='Patient_ID',
            field=models.ForeignKey(default=1, on_delete=django.db.models.deletion.CASCADE, to='patient.patient'),
            preserve_default=False,
        ),
    ]
