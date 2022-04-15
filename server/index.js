const { server } = require('./server');
const { generateClient } = require('./client');

server.listen(3000);
const client = generateClient('ws://localhost:3000');

client.emit('hey', 'daaa');

let count = 0;
setInterval(() => {
  client.emit('hey', count++);
}, 1000);