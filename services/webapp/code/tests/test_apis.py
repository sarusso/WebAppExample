import json
import logging
from .common import BaseAPITestCase
from django.contrib.auth.models import User
from .. import apis
from ..models import SampleObject


# Logging
logging.basicConfig(level=logging.ERROR)
logger = logging.getLogger("edjango")


class ApiTests(BaseAPITestCase):

    def setUp(self):
        
        # Create test user
        self.user = User.objects.create_user('testuser', password='testpass')
        self.user.save()


    def test_auth(self):
     
        # No user at all
        resp = self.post('/api/v1/sampleobject/add', data={'name': 'My First Sample Object'})
        self.assertEqual(json.loads(resp.content), {"status": "ERROR", "detail": "This is a private API. Login or provide username/password"})

        # Wrong user
        resp = self.post('/api/v1/sampleobject/add', data={'name': 'My First Sample Object', 'username':'wronguser', 'password':'testpass'})
        self.assertEqual(json.loads(resp.content), {"status": "ERROR", "detail": "Wrong username/password"})

        # Wrong pass
        resp = self.post('/api/v1/sampleobject/add', data={'name': 'My First Sample Object', 'username':'testuser', 'password':'wrongpass'})
        self.assertEqual(json.loads(resp.content), {"status": "ERROR", "detail": "Wrong username/password"})

        # Correct user
        resp = self.post('/api/v1/sampleobject/add', data={'name': 'My First Sample Object', 'username': 'testuser', 'password':'testpass'})
        self.assertEqual(json.loads(resp.content)['status'], 'OK')

        
    def test_sample_object_api(self):

        # Missing object name
        resp = self.post('/api/v1/sampleobject/add', data={'name': 'My First Sample Object', 'username': 'testuser', 'password':'testpass'})
        response = json.loads(resp.content)
        self.assertEqual(response['status'], 'OK')
        self.assertTrue('sample_object_id' in response['data'])
        
        # Check for correct URL field creation
        sampleObject = SampleObject.objects.get(user=self.user, id=response['data']['sample_object_id'])
        self.assertEqual(sampleObject.user.username, 'testuser')




        
        
        
        
        
        
        