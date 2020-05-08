const http = require('http');
const express = require('express');
const { Server } = require('ws');

const app = express();
app.use(express.static(__dirname + "/"));
const httpServer = http.createServer(app);
const port = process.env.APP_BACKEND_PORT || 3032;
httpServer.listen(port, () => {
  console.log(`Server listening on port ${port} `, process.env.PORT);
});

const wss = new Server({
  server: httpServer,
});

let clients = [];

wss.on('connection', ws => {
  const id = (Math.random() * 10000);
  clients.push({ ws, id });
  console.log('Client connected', id);

  ws.on('message', message => {
    console.log(message, typeof message);
    clients
      .filter(client => client.id !== id)
      .forEach(client => client.ws.send(message));
  });

  ws.on('close', () => {
    clients = clients.filter(client => client.id !== id);
  });
});