# Generated by Django 5.1.1 on 2024-11-08 23:59

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('appointment', '0001_initial'),
    ]

    operations = [
        migrations.AddField(
            model_name='appointment',
            name='Is_Rate',
            field=models.BooleanField(default=False),
        ),
    ]