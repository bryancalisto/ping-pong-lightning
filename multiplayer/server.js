const socketio = require('socket.io');
const { processStartNewGame, processJoinGame, badRequest } = require('./controller');
const { events } = require('./events');

class Server {
  clients = [];
  io = null;

  constructor() {
    this.io = socketio();

    this.io.on('connection', (socket) => {
      this.clients.push(socket);

      socket.on(events.req.startNewGame, (data) => {
        processStartNewGame(socket);
      });

      socket.on(events.req.joinGame, (data) => {
        processJoinGame(socket);
      });
    });
  }

  closeClients() {
    this.clients.forEach(client => {
      client.close();
    });
  }

  close() {
    this.io.close();
  }
}

module.exports = {
  Server
};