const gameStatus = {
  idle: 'idle',
  waitingPlayers: 'waitingPlayers',
  loading: 'loading',
  readyToStart: 'readyToStart',
  running: 'running',
  paused: 'paused',
  finished: 'finished'
};

class Game {
  player1 = null;
  player2 = null;
  status = gameStatus.idle;
}

class Player {
  lostPings = 0;
  connectionMonitorRef = 0;
  socket = null;
  points = 0;
  online = true;
  playing = false;

  constructor(socket) {
    this.socket = socket;
  }
}

class Ball {
  x = 0;
  y = 0;
  goingUp = false;
  goingRight = false;
}

class Racket {
  x = 0;
  goingRight = false;
}

module.exports = {
  gameStatus,
  Game,
  Player,
  Ball,
  Racket
};