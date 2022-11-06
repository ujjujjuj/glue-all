const TcpServer = require("./TCPserver");

const server = new TcpServer(31337);

server.get("PING", (s, data) => {
  s.send({ ...data, type: "PING", transferType: "SINGLE" });
});

server.get("AUTH", (s, data) => {
  console.log(data);
  // check if token is valid, send packet if token is wrong
  // ...
  // assuming token provided is correct
  if (!server.rooms[data.token]) {
    server.rooms[data.token] = {};
  }
  const token = data.token;
  delete data.token;
  server.rooms[token][s.id] = { ...data };
  server.clients[s.id] = {
    room: token,
    socket: s,
    hostname: data.hostname,
    platform: data.platform,
    localAddress: data.localAddress,
    remoteAddress: data.remoteAddress,
    // networkInterfaces: data.networkInterfaces,
  };
  s.send({ type: "AUTH_OK", id: s.id });
});

server.get("CLIP_TEXT", (s, data) => {
  server.broadcast(
    { transferType: "BROADCAST", type: "CLIP_TEXT", ...data },
    server.clients[s.id].room,
    s.id
  );
  console.log(data);
});

server.get("CLIP_FILE", (s, data) => {
  const client = server.clients[data.otherId].socket;
  server.send(
    client,
    {
      transferType: "SINGLE",
      type: "CLIP_FILE",
      file: data.file,
      fileName: data.fileName,
    },
    server.clients[s.id].room,
    s.id
  );
});

server.get("CLIP_FILE_ENDED", (s, data) => {
  server.broadcast(
    { transferType: "BROADCAST", type: "CLIP_FILE_ENDED", ...data },
    server.clients[s.id].room,
    s.id
  );
});

server.get("DISCOVER", (s, data) => {
  const room = server.clients[s.id].room;

  const clientInfo = Object.keys(server.rooms[room])
    .filter((id) => s.id != id)
    .map((id) => {
      return { ...server.clients[id], id };
    });

  s.send({ transferType: "SINGLE", type: "DISCOVER", data: clientInfo });
});

module.exports = { server };
