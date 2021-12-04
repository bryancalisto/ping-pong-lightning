from django.urls import path

from .consumers import WsConsumer

ws_urlpatters = [
    path('ws/some_url/', WsConsumer.as_asgi())
]
