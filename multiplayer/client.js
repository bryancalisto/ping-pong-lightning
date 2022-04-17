const socketio = require('socket.io-client');

class Client {
  id = null;
  io = null;

  constructor(url, configs) {
    this.io = socketio(url, {
      autoConnect: false,
      reconnectionDelayMax: 10000,
      ...configs
    });

    this.id = this.io.id;
  }

  addListener(event, callback) {
    this.io.on(event, callback);
  }

  connect() {
    this.io.connect();
  }
}

module.exports = {
  Client
};