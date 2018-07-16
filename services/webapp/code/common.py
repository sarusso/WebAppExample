import os
import random
import datetime
import traceback
import pytz
import hashlib
import subprocess
from collections import namedtuple
from edjango.common.utils import format_exception

# Setup logging
import logging
logger = logging.getLogger(__name__)


#=========================
# Utility functions
#=========================

def get_md5(string):
    if not string:
        raise Exception("Colund not compute md5 of empty/None value")
    import hashlib
    m = hashlib.md5()
    try:
        m.update(string)
    except UnicodeError:
        m.update(string.encode('utf-8'))
    md5 = str(m.hexdigest())
    return md5


def timezonize(timezone):
     
    if (isinstance(timezone, str) or isinstance(timezone, unicode)): 
        try:
            timezone = pytz.timezone(timezone)
        except Exception as e:
            logger.error(format_exception(e))
            raise ValueError('timezone not valid, got "{}"'.format(timezone))

    else:
        try:
            test = datetime.datetime(2015,1,1,0,0, tzinfo=pytz.UTC)
            test.astimezone(timezone)
        except Exception, e:
            raise ValueError("timezone or "+str(e))
    
    return timezone


