from random import randint
from time import sleep
import json

from channels.generic.websocket import WebsocketConsumer
from asgiref.sync import async_to_sync


class WsConsumer(WebsocketConsumer):

    def connect(self):
        # self.accept()

        # for i in range(100):
        #     self.send(json.dumps({'message': randint(1, 1000)}))
        #     sleep(1)

        self.room_name = self.scope['url_route']['kwargs']['room_name']  # the scope method gets the room name from the url path
        self.room_group_name = 'chat_%s' % self.room_name  # a group is created, and is given the name of "room name"

        # Join room group
        async_to_sync(self.channel_layer.group_add)(
            self.room_group_name,
            self.channel_name
        )
        self.accept()  # websocket connection is accepted

    def disconnect(self, close_code):  # [Close Event] and [Error Event]
        # Leave room group
        async_to_sync(self.channel_layer.group_discard)(
            self.room_group_name,
            self.channel_name
        )

    def receive(self, text_data):  # [Message Event]
        text_data_json = json.loads(text_data)
        message = text_data_json['message']
        # Send message to room group
        async_to_sync(self.channel_layer.group_send)(  # channel_layer is an async function, async_to_async module makes it synchroronous, since it is to be used in a synchronous consumer
            self.room_group_name,
            {
                'type': 'chat_message',
                'message': message
            }
        )

    def chat_message(self, event):
        message = event['message']
        # Send message to WebSocket
        self.send(text_data=json.dumps({  # message is sent back as it is received
            'message': message
        }))
