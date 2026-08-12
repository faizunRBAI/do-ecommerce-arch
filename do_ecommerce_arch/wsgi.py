import os

from django.core.wsgi import get_wsgi_application

os.environ.setdefault("DJANGO_SETTINGS_MODULE", "do_ecommerce_arch.settings")
application = get_wsgi_application()
