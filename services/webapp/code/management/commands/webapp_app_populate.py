from django.core.management.base import BaseCommand
from django.contrib.auth.models import User
from ...models import Profile

class Command(BaseCommand):

    def handle(self, *args, **kwargs):
        
        # Define test user
        email    = 'testuser@web.app'
        username = 'taqvgbghmlceifee'
        password = 'testpass' 
        
        if User.objects.filter(email=email).exists():
            
            print "Django user for testuser alredy exists, skipping..."

        else:
            
            # Set that we _are_ populating for the first time
            first_time = True
            
            # Create test user
            print 'Creating test user with mail={}'.format(email) 
            testuser = User.objects.create_user(username, password=password, email=email)
            Profile.objects.create(user=testuser)
            testuser.save()






                
