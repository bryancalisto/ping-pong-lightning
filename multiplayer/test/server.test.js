const { Server } = require("../server");
const sinon = require('sinon');
const { Client } = require("../client");
const { assert } = require("chai");
const { generateRandomPort } = require("./utils");
const PORT = generateRandomPort();
const URL = 'ws://localhost:' + PORT;

let server;

beforeAll(() => {
  server = new Server();
  server.io.listen(PORT);
});

afterAll(done => {
  server.close();
  done();
});

describe('Server', () => {
  it('On connection adds the client socket to the clients list', (done) => {
    const fn = sinon.fake();

    server.addListener('connection', (socket) => fn());

    const client1 = new Client(URL);
    client1.connect();

    const client2 = new Client(URL);

    // The client2's connection confirmation event is the last thing that happens in this process, so set assertions and
    // cleanup there
    client2.addListener('connect', () => {
      sinon.assert.calledTwice(fn);
      assert.equal(server.clients.length, 2);
      client1.io.close();
      client2.io.close();
      done();
    });
    client2.connect();
  });
});