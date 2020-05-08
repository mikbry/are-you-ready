const http = require('http');
const { Server } = require('ws');

const httpServer = http.createServer(() => { });
const port = process.env.APP_BACKEND_PORT | 3032;
httpServer.listen(port, () => {
  console.log('Server listening at port ' + port);
});

const wss = new Server({
  httpServer,
});

let clients = [];

wss.on('connection', ws => {
  const id = (Math.random() * 10000);
  clients.push({ ws, id });
  console.log('Client connected', id);

  ws.on('message', message => {
    console.log(message);
    clients
      .filter(client => client.id !== id)
      .forEach(client => client.connection.send(message.utf8Data));
  });

  ws.on('close', () => {
    clients = clients.filter(client => client.id !== id);
  });
});