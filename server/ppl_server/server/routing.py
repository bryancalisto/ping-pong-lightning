from django.urls import re_path

from . import consumers

ws_urlpatters = [
    re_path(r'ws/chat/(?P<room_name>\w+)/$', consumers.WsConsumer.as_asgi())
]
