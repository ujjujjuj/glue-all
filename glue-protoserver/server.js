const net = require("net");
const BSON = require("bson");
const { randomUUID } = require("crypto");
const msgpackr = require("msgpackr");
const fs = require("fs");
const zlib = require("zlib");

// const BUF_LEN_MAX = 8;

class TcpServer {
  constructor(port) {
    this.ss = net.createServer();
    this.port = port;
    this.routes = {};
    this.rooms = {};
    this.clients = {};
  }
  start() {
    this.ss.listen(this.port, () => {
      console.log(`[-] Server is now listening`);
    });

    this.ss.on("connection", (s) => {
      s.id = randomUUID();
      s.setNoDelay(true);
      console.log(`[+] Client connected`);
      this.clients[s.id] = { processing: false };
      s.on("data", (data) => this.ondata(s, data));
      s.on("close", () => {
        const room = this.clients[s.id].room;
        delete this.rooms[room][s.id];
        delete this.clients[s.id];
        if (Object.keys(this.rooms[room]).length === 0) delete this.rooms[room];
        console.log(`[+] Client left`);
      });
    });
  }

  

  ondata(s, buf) {
    console.log(buf);
    if (buf.length === 0) return;
    if (this.clients[s.id].isProcessing) {
      if (buf.length >= this.clients[s.id].lengthRemaining) {
        buf = Buffer.concat([...this.clients[s.id].buffers, buf]);
        this.clients[s.id].buffers = null;
      } else {
        this.clients[s.id].buffers.push(buf);
        this.clients[s.id].lengthRemaining -= buf.length;
        return;
      }
    } else {
      const length = buf.readInt32LE(0);
      if (buf.length < length - 4) {
        this.clients[s.id].isProcessing = true;
        this.clients[s.id].lengthRemaining = length - buf.length - 4;
        this.clients[s.id].buffers = [buf];
        // this.clients[s.id].temporaryBuf = buf;
        return;
      }
    }

    this.clients[s.id].isProcessing = false;
    const length = buf.readInt32LE(0);
    const data = buf.subarray(4, length + 4);
    const obj = msgpackr.unpack(data);
    if (Object.keys(this.routes).includes(obj.type)) {
      s.send = this.send.bind(this, s);
      const type = obj.type;
      delete obj.type;
      this.routes[type](s, obj);
    } else {
      console.log(`Unknown route ${obj.type}`);
    }
    this.ondata(s, buf.subarray(length + 4));
  }

  send(s, obj) {
    const data = msgpackr.encode(obj);
    const length = data.length;
    const buf = Buffer.alloc(length + 4);
    buf.writeInt32LE(length, 0);
    data.copy(buf, 4, 0, length);
    s.write(buf);
  }

  get(route, handler) {
    this.routes[route] = handler;
  }

  broadcast(obj, room, sourceSock) {
    Object.keys(this.rooms[room])
      .filter((clientId) => clientId !== sourceSock)
      .forEach((clientId) => {
        this.send(this.clients[clientId].socket, obj);
      });
  }
}

const server = new TcpServer(31337);

server.get("PING", (s, data) => {
  s.send({ ...data, type: "PONG" });
});
server.get("AUTH", (s, data) => {
  // check if token is valid, send packet if token is wrong
  // ...
  // assuming token provided is correct
  if (!server.rooms[data.token]) {
    server.rooms[data.token] = {};
  }
  const token = data.token;
  delete data.token;
  server.rooms[token][s.id] = { ...data };
  server.clients[s.id] = { room: token, socket: s };
  s.send({ type: "AUTH_OK", id: s.id });
});

server.get("CLIP_TEXT", (s, data) => {
  console.log(data);
  server.broadcast(
    { type: "CLIP_TEXT", ...data },
    server.clients[s.id].room,
    s.id
  );
});

server.get("CLIP_FILE", (s, data) => {
  // s.send({ type: "CLIP_FILE", file: data.file });
  fs.writeFileSync("file2", data.file);
  console.log("saved file");
});

const main = async () => {
  server.start();
};

main();
