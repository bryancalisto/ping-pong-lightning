const { Client } = require("../client");
const { Server } = require("../server");
const { events } = require('../events');
const { assert } = require('chai');
const sinon = require('sinon');
let game = require('../game');
const { gameStatus, Game, Player } = require("../models");
const { generateRandomPort } = require("./utils");
const PORT = generateRandomPort();
const URL = 'ws://localhost:' + PORT;
const setupServer = require('../serverSetup');

let server;
let client;

beforeAll(() => {
  server = new Server();
  setupServer(server);
  server.io.listen(PORT);
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
    client = new Client(URL);

    client.addListener(events.info.type, (data) => {
      assert.equal(data, events.info.ok);
      done();
    });

    client.connect();

    client.io.emit(events.req.startNewGame);
  });

  it('should receive error if status is different than idle', (done) => {
    game.status = gameStatus.waitingPlayers;
    client = new Client(URL);

    client.addListener(events.error.type, (data) => {
      assert.notEqual(game.status, events.error.gameAlreadyRunning);
      assert.equal(data, events.error.gameAlreadyRunning);
      done();
    });

    client.connect();
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
    client = new Client(URL);

    client.addListener(events.info.type, (data) => {
      const game = require('../game'); // To avoid state 'game' variable
      assert.equal(data, events.info.ok);
      assert.isOk(game.player1);
      assert.isNull(game.player2);
      done();
    });

    client.connect();
    client.io.emit(events.req.joinGame);
  });

  it('should register player2', (done) => {
    game.status = gameStatus.waitingPlayers;
    game.player1 = new Player('1234'); // Simulate a player already registered
    client = new Client(URL);

    client.addListener(events.info.type, (data) => {
      const game = require('../game');
      assert.equal(data, events.info.ok);
      assert.equal(game.status, gameStatus.readyToStart);
      assert.isOk(game.player1);
      assert.isOk(game.player2);
      done();
    });

    client.connect();
    client.io.emit(events.req.joinGame);
  });

  it('should receive error if there is no space for more players', (done) => {
    game.status = gameStatus.waitingPlayers;
    game.player1 = new Player('1234');
    game.player2 = new Player('1234');
    client = new Client(URL);

    client.addListener(events.error.type, (data) => {
      const game = require('../game');
      assert.equal(data, events.error.tooManyPlayers);
      assert.isOk(game.player1);
      assert.isOk(game.player2);
      done();
    });

    client.connect();
    client.io.emit(events.req.joinGame);
  });
});

// describe('pong', () => {
//   beforeAll(() => {
//     // jest.useFakeTimers();
//   });

//   beforeEach(() => {
//     game = new Game();
//   });

//   afterEach(() => {
//     client.io.close();
//     jest.clearAllTimers();
//   });

//   it('should update player state to online=false if the user has not responded 2 pings', (done) => {
//     const pingCallback = sinon.mock();
//     game.status = gameStatus.waitingPlayers;

//     client = new Client(URL);
//     client.addListener(events.info.ping, pingCallback);
//     client.addListener(events.info.type, (data) => { // For joinGame request
//       jest.useFakeTimers();
//       const game = require('../game'); // To avoid state 'game' variable
//       assert.equal(game.player1.online, true);
//       jest.advanceTimersByTime(3000); // The first ping has not been answered
//       jest.advanceTimersByTime(3000);// Wait timeout
//       assert.equal(game.player1.lostPings, 1);
//       jest.advanceTimersByTime(5001); // The first ping has not been answered
//       // jest.advanceTimersByTime(10000); // The seconds ping was generated and has not been answered
//       // assert.equal(game.player1.lostPings, 2);
//       // assert.equal(game.player1.online, false);
//       done();
//     });

//     client.connect();
//     client.io.emit(events.req.joinGame); // The first ping is generated
//   });

// });