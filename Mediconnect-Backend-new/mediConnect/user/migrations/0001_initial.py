# Generated by Django 5.1.1 on 2024-09-29 18:25

from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='User',
            fields=[
                ('User_ID', models.BigAutoField(primary_key=True, serialize=False)),
                ('Email', models.EmailField(max_length=254)),
                ('Password', models.CharField(max_length=255)),
                ('Device_ID', models.CharField(max_length=255)),
            ],
        ),
    ]
