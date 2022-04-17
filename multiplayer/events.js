const events = {
  error: {
    type: 'error',
    gameAlreadyRunning: 'gameAlreadyRunning',
    tooManyPlayers: 'tooManyPlayers',
    badRequest: 'badRequest'
  },
  info: {
    type: 'info',
    ok: 'ok',
    ping: 'ping',
    pong: 'pong'
  },
  req: {
    type: 'req',
    startNewGame: 'startNewGame',
    joinGame: 'joinGame'
  }
};

module.exports = {
  events
};