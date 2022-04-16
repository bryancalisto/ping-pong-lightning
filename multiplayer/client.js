const socketio = require('socket.io-client');
const { events } = require('./events');

class Client {
  id = null;
  io = null;

  constructor(url, configs) {
    this.io = socketio(url, {
      reconnectionDelayMax: 10000,
      ...configs
    });

    this.id = this.io.id;
  }

  addListener(event, callback) {
    this.io.on(event, callback);
  }
}

module.exports = {
  Client
};