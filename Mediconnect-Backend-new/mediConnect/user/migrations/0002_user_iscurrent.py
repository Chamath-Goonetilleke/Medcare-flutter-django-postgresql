# Generated by Django 5.1.1 on 2024-11-09 18:11

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('user', '0001_initial'),
    ]

    operations = [
        migrations.AddField(
            model_name='user',
            name='IsCurrent',
            field=models.BooleanField(default=False),
        ),
    ]
