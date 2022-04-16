const { Client } = require("../client");
const { Server } = require("../server");
const { events } = require('../events');
const { assert } = require('chai');
let game = require('../game');
const { gameStatus, Game, Player } = require("../models");

let server;
let client;

beforeAll(() => {
  server = new Server();
  server.io.listen(3000);
});

afterAll(done => {
  server.close();
  done();
});

describe('processStartNewGame', () => {
  beforeEach(() => {
    game = new Game();
  });

  afterEach(() => {
    client.io.close();
  });

  it('should change game status to waitingPlayers', (done) => {
    client = new Client('ws://localhost:3000');

    client.addListener(events.info.type, (data) => {
      assert.equal(data, events.info.ok);
      done();
    });

    client.io.emit(events.req.startNewGame);
  });

  it('should receive error if status is different than idle', (done) => {
    game.status = gameStatus.waitingPlayers;
    client = new Client('ws://localhost:3000');

    client.addListener(events.error.type, (data) => {
      assert.notEqual(game.status, events.error.gameAlreadyRunning);
      assert.equal(data, events.error.gameAlreadyRunning);
      done();
    });

    client.io.emit(events.req.startNewGame);
  });
});

describe('processJoinGame', () => {
  beforeEach(() => {
    game = new Game();
  });

  afterEach(() => {
    client.io.close();
  });

  it('should register player1', (done) => {
    game.status = gameStatus.waitingPlayers;
    client = new Client('ws://localhost:3000');

    client.addListener(events.info.type, (data) => {
      const game = require('../game'); // To avoid state 'game' variable
      assert.equal(data, events.info.ok);
      assert.isOk(game.player1);
      assert.isNull(game.player2);
      done();
    });

    client.io.emit(events.req.joinGame);
  });

  it('should register player2', (done) => {
    game.status = gameStatus.waitingPlayers;
    game.player1 = new Player('1234'); // Simulate a player already registered
    client = new Client('ws://localhost:3000');

    client.addListener(events.info.type, (data) => {
      const game = require('../game');
      assert.equal(data, events.info.ok);
      assert.equal(game.status, gameStatus.readyToStart);
      assert.isOk(game.player1);
      assert.isOk(game.player2);
      done();
    });

    client.io.emit(events.req.joinGame);
  });

  it('should receive error if there is no space for more players', (done) => {
    game.status = gameStatus.waitingPlayers;
    game.player1 = new Player('1234');
    game.player2 = new Player('1234');
    client = new Client('ws://localhost:3000');

    client.addListener(events.error.type, (data) => {
      const game = require('../game');
      assert.equal(data, events.error.tooManyPlayers);
      assert.isOk(game.player1);
      assert.isOk(game.player2);
      done();
    });

    client.io.emit(events.req.joinGame);
  });
});