const { Server } = require('./server');
const { Client } = require('./client');

const server = new Server();
server.io.listen(3000);
const client = Client('ws://localhost:3000');

client.io.emit('hey', 'daaa');

let count = 0;
setInterval(() => {
  client.io.emit('hey', count++);
}, 1000);