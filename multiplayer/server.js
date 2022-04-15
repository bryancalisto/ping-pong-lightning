const server = require('socket.io')();

server.on('connection', (socket) => {
  socket.emit('ev1', 'sending ev1 from server');

  socket.on('hey', (arg) => {
    console.log('incoming from client:', arg);
  });
});

module.exports = {
  server
};