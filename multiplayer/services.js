const { GameAlreadyRunning, TooManyPlayers } = require('./exceptions');
const { gameStatus } = require('./models');
let game = require('./game');
const { events } = require('./events');

const startNewGame = () => {
  if (game.status !== gameStatus.idle) {
    throw new GameAlreadyRunning();
  }

  game.status = gameStatus.waitingPlayers;
}

const resetGame = () => {
  game.status = gameStatus.idle;
  game.player1 = null;
  game.player2 = null;
}

const addPlayerToGame = (player) => {
  if (!game.player1) {
    game.player1 = player;
  }
  else if (!game.player2) {
    game.player2 = player;
    game.status = gameStatus.readyToStart;
  }
  else {
    throw new TooManyPlayers();
  }
};

const updatePlayerConnection = (socket, resetLostPings) => {
  let playerToUpdate = null;

  if (game.player1 === socket.id) {
    playerToUpdate = game.player1;
  }

  if (game.player2 === socket.id) {
    playerToUpdate = game.player2;
  }

  if (playerToUpdate) {
    if (resetLostPings) {
      playerToUpdate.lostPings = 0;
    }
    else {
      playerToUpdate.lostPings++;
    }
  }

  if (playerToUpdate.lostPings > 2) {
    game.player1.online = false;
  }
  else {
    game.player1.online = true;
  }
};

const monitorPlayerConnection = (socket) => {
  return setInterval(() => {
    console.log(' INTERVAL')
    const timeoutRef = setTimeout(() => {
      console.log(' TIMEOUT')
      updatePlayerConnection(socket, false);
    }, 1000);

    socket.emit(events.info.ping, () => {
      clearTimeout(timeoutRef);
      updatePlayerConnection(socket, true);
    });
    // }, 10000);
  }, 3000);
}

module.exports = {
  game,
  startNewGame,
  resetGame,
  addPlayerToGame,
  monitorPlayerConnection
};