from django.db import models, transaction


# Create your models here.
class User(models.Model):
    User_ID = models.BigAutoField(primary_key=True)
    Email = models.EmailField()
    Password = models.CharField(max_length=255)
    Device_ID = models.CharField(max_length=256)
    IsRegistered = models.BooleanField(default=False)
    IsCurrent = models.BooleanField(default=False)
    Role = models.CharField(max_length=255, null=True)

    def set_as_current_user(self):
        """
        Sets the current user as the active user for their Device_ID and
        deactivates all other users with the same Device_ID.
        """
        with transaction.atomic():
            # Set IsCurrent=False for all users with the same Device_ID
            User.objects.filter(
                Device_ID=self.Device_ID,
                IsCurrent=True
            ).update(IsCurrent=False)

            # Set the current user as active
            self.IsCurrent = True
            self.save()
