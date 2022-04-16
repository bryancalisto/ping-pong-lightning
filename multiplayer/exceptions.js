class GameAlreadyRunning extends Error {
  constructor() {
    super('The game is already running');
  }
}

class TooManyPlayers extends Error {
  constructor() {
    super('A game only supports two players');
  }
}

module.exports = {
  GameAlreadyRunning,
  TooManyPlayers
};