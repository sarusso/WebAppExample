from django.conf.urls import url

from . import views
from . import apis

urlpatterns = [
    # Views (public)
    url(r'^$', views.main, name='main'),
    url(r'^main/$', views.main, name='main'),
    url(r'^login/$', views.user_login, name='login'),
    url(r'^logout/$', views.user_logout, name='logout'),
    url(r'^register/$', views.register, name='main'),

    # Views (private)
    url(r'^account/$', views.account, name='account'),
        
    # APIs (private)
    url(r'^api/v1/sampleobject/add$', apis.sampleobject_api.as_view(), name='api_url_init'),
  
]