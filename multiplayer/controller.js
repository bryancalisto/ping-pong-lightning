const { GameAlreadyRunning, TooManyPlayers } = require('./exceptions');
const { Player } = require('./models');
const { startNewGame, addPlayerToGame, monitorPlayerConnection } = require('./services');
const { events } = require('./events');

const processStartNewGame = (client) => {
  try {
    startNewGame();
    client.emit(events.info.type, events.info.ok);
  } catch (e) {
    if (e instanceof GameAlreadyRunning) {
      client.emit(events.error.type, events.error.gameAlreadyRunning);
    }
  };
};

const processJoinGame = (client) => {
  try {
    const newPlayer = new Player(client);
    addPlayerToGame(newPlayer);
    client.emit(events.info.type, events.info.ok);
    // Keep track of player's connection
    // newPlayer.connectionMonitorRef = monitorPlayerConnection(client);
  } catch (e) {
    if (e instanceof TooManyPlayers) {
      client.emit(events.error.type, events.error.tooManyPlayers);
    }
  };
};

const badRequest = (client) => {
  client.emit(events.error.badRequest);
}


module.exports = {
  processStartNewGame,
  processJoinGame,
  badRequest
};