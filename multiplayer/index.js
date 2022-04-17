const { Server } = require('./server');
const { Client } = require('./client');
const setupServer = require('./serverSetup');

const server = new Server();
setupServer(server);

server.io.listen(3000);

const client = new Client('ws://localhost:3000');

client.addListener('hello', () => {
  client.io.emit('world')
});

let count = 0;
setInterval(() => {
  server.io.emit('hello', count++);
}, 3000);