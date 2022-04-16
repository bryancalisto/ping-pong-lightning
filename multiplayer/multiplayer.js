const { GameAlreadyRunning, TooManyPlayers } = require('./exceptions');
const { gameStatus } = require('./models');
let game = require('./game');

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
  console.log('EST:', game.status);
  if (!game.player1) {
    console.log('PLAY1');
    game.player1 = player;
  }
  else if (!game.player2) {
    console.log('PLAY2');
    game.player2 = player;
    game.status = gameStatus.readyToStart;
    console.log('SET ', gameStatus.readyToStart);
  }
  else {
    console.log('TOO');
    throw new TooManyPlayers();
  }
};

module.exports = {
  game,
  startNewGame,
  resetGame,
  addPlayerToGame
};