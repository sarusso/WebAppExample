from django.db import models
from django.contrib.auth.models import User
import uuid

#------------------
# User profile
#------------------

class Profile(models.Model):
    user     = models.OneToOneField(User, on_delete=models.CASCADE)
    timezone = models.CharField('User Timezone', max_length=36, default='UTC')
    uuid     = models.CharField('User UUID', max_length=36, blank=True, null=True)

    def save(self, *args, **kwargs):
        if not self.uuid:
            self.uuid = str(uuid.uuid4())
        super(Profile, self).save(*args, **kwargs)

    def __unicode__(self):
        return str('Profile of user "{}" on timezone "{}"'.format(self.user.email, self.timezone))


#------------------
# Sample Object
#------------------

class SampleObject(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    name = models.CharField('Object Name', max_length=36)

    def __unicode__(self):
        return str('Sample object named "{}" for user "{}"'.format(self.name, self.user.email))








