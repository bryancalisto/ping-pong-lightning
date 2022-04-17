const socketio = require('socket.io');

class Server {
  clients = [];
  io = null;

  constructor() {
    this.io = socketio();
  }

  addListener(event, callback) {
    if (event === 'connection') { // Override to include incoming socket to clients list
      const overridenCallback = (socket) => {
        this.clients.push(socket);
        callback(socket);
      };

      this.io.on(event, overridenCallback);
      return;
    }

    this.io.on(event, callback);
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