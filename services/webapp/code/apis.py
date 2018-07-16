import traceback
from rest_framework.response import Response
from rest_framework import status
from rest_framework.views import APIView

from django.contrib.auth import authenticate
from models import SampleObject


#-------------------------
# Setup logging
#-------------------------
import logging
logger = logging.getLogger(__name__)

CRITICAL = 50
ERROR    = 40
WARNING  = 30
INFO     = 20
DEBUG    = 10
NOTSET   = 0


#-------------------------
# Utility functions
#-------------------------

def format_exception(e, debug=False):
    if debug:
        return 'Exception: ' + str(e) + '; Traceback: ' + traceback.format_exc()
    else:
        return 'Exception: ' + str(e) + '; Traceback: ' + traceback.format_exc().replace('\n','|')


#---------------------------
# Common returns
#---------------------------

# Ok (with data)
def ok200(data=None):
    return Response({"status": "OK", "data": data}, status=status.HTTP_200_OK)

# Error 400
def error400(error_msg=None):
    return Response({"status": "ERROR", "detail": error_msg}, status=status.HTTP_400_BAD_REQUEST)

# Error 401
def error401(error_msg=None):
    return Response({"status": "ERROR", "detail": error_msg}, status=status.HTTP_401_UNAUTHORIZED)

# Error 404
def error404(error_msg=None):
    return Response({"status": "ERROR", "detail": error_msg}, status=status.HTTP_404_NOT_FOUND)

# Error 500
def error500(error_msg=None):
    return Response({"status": "ERROR", "detail": error_msg}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


#---------------------------
#  Base private API class
#---------------------------
class privateAPI(APIView):
    '''Base private API class'''

    payload_encrypter = None

    def post(self, request):

        try:         
            # Check user authentication
            if not request.user.is_authenticated() and 'username' not in request.data and 'password' not in request.data:
                return error401(error_msg='This is a private API. Login or provide username/password')
            
            elif not request.user.is_authenticated() or ('username' in request.data and 'password' in request.data):
                
                # logger.info 'Authenticating'
                
                # Try to authenticate
                try:
                    username = request.data["username"] # Not request.POST
                except:
                    username = None       
    
                try:
                    password = request.data["password"]
                except:
                    password = None  
        
                # Sanity checks
                if not username:
                    return error400(error_msg='Got empty username')
                if not password:
                    return error400(error_msg='Got empty password')
    
                # Authenticate
                user = authenticate(username=username, password=password)
                if not user:
                    return error401(error_msg='Wrong username/password')  
                else:
                    self.user = user                   
                    # Call API logic 
                    return self._post(request)
            else:
                self.user = request.user
                # Call API logic 
                return self._post(request)
                      
        except Exception,e:
            logger.error(format_exception(e, debug=False))
            return error500(error_msg='Got exception in processing request: ' + str(e))

    def get(self, request):
        try:         
            # Check user authentication
            if not request.user.is_authenticated() and 'username' not in request.GET and 'password' not in request.GET:
                return error401(error_msg='This is a private API. Login or provide username/password or token')
            
            elif not request.user.is_authenticated() or ('username' in request.GET and 'password' in request.GET):

                # Try to authenticate
                try:
                    username = request.GET["username"]
                except:
                    username = None       
    
                try:
                    password = request.GET["password"]
                except:
                    password = None  
        
                # Sanity checks
                if not username:
                    return error400(error_msg='Got empty username')
                if not password:
                    return error400(error_msg='Got empty password')
    
                # Authenticate
                user = authenticate(username=username, password=password)
                if not user:
                    return error401(error_msg='Wrong username/password')  
                else:
                    self.user = user                   
                    # Call API logic 
                    return self._get(request)
            else:
                self.user = request.user
                # Call API logic 
                return self._get(request)
                      
        except Exception,e:
            logger.error(format_exception(e, debug=False))
            return error500(error_msg='Got exception in processing request: ' + str(e))


    def log(self, level, msg, *strings):
        logger.log(level, self.__class__.__name__ + ': ' + str(self.user) + ': ' + msg, *strings)


#----------------------------
#      Sample POST API
#   (create a SampleObject)
#----------------------------

class sampleobject_api(privateAPI):
    '''Sample POST API (create sample object)'''

    def _post(self, request):

        # Obtain value
        name = request.data.get('name', None)

        # Sanity checks
        if not id:
            return error400('Got empty "id"')
           
        # Check if url already present
        sampleObject, created = SampleObject.objects.get_or_create(user=self.user, name=name)

        # Ok, return
        if created:
            return ok200(data={'sample_object_id': str(sampleObject.id)})
        else:        
            return error400('Object with this name already present for this user')
        





