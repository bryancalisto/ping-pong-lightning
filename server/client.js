const io = require('socket.io-client');

const generateClient = (url, configs) => {
  const client = io(url, {
    reconnectionDelayMax: 10000,
    ...configs
  });

  client.on('ev1', (data) => {
    console.log(data);
  });

  return client;
};

module.exports = {
  generateClient
};