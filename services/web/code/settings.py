
# Settings that you put here will be included in the Django settings.
# You can even overwrite (i.e. put here INSTALLED_APPS=() to break everything),
# so use something something like YOURAPP_YOURSETTINGS for naming your settings.

# If you want to modifiy a setting, just assing it. I.e.:
#DEBUG=False

# If you need to add something to a setting you first have to import.
from edjango.settings.common import INSTALLED_APPS
INSTALLED_APPS = INSTALLED_APPS + (
    'rest_framework',
)
