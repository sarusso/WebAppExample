import json
import logging
from ..common import timezonize
from django.test import TestCase


# Logging
logging.basicConfig(level=logging.ERROR)
logger = logging.getLogger("edjango")


class ApiTests(TestCase):

    def setUp(self):
        pass
    
    def test_timezonize(self):
        timezonize('Europe/Rome')

    def tearDown(self):
        pass        