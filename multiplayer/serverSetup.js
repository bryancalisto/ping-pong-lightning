const { processJoinGame, processStartNewGame } = require("./controller");
const { events } = require("./events");

const setup = (server) => {
  server.addListener('connection', (socket) => {
    socket.on(events.req.startNewGame, (data) => {
      processStartNewGame(socket);
    });

    socket.on(events.req.joinGame, (data) => {
      processJoinGame(socket);
    });
  });
};

module.exports = setup;