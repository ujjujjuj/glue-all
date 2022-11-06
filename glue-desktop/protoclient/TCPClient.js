const net = require("net");
const os = require("os");
const fs = require("fs");
const msgpackr = require("msgpackr");

class TCPClient {
  constructor(host, port, token) {
    this.host = host;
    this.port = port;
    this.token = token;
    this.routes = {};
    this.disconnectResolve = null;
    this.reinitialize();
    this.isProcessing = false;
    this.temporaryBuf = null;
  }

  reinitialize() {
    this.s = new net.Socket();
    this.ns = new net.Socket();
    this.s.setNoDelay(true);
    this.state = { auth: false, id: null };
  }

  connect() {
    let connectResolve, connectReject;
    let connectPromise = new Promise((resolve, reject) => {
      connectResolve = resolve;
      connectReject = reject;
    });

    this.s.connect({ host: this.host, port: this.port });
    this.s.on("connect", () => {
      console.log(`[-] Connected to server`);
      connectResolve();
    });
    this.s.on("data", this.ondata.bind(this));
    this.s.on("close", () => {
      console.log(`[-] Disconnected from server`);
      if (this.disconnectResolve) this.disconnectResolve();
    });
    this.s.on("error", () => connectReject());

    return connectPromise;
  }

  waitForDisonnect() {
    return new Promise((resolve) => (this.disconnectResolve = resolve));
  }

  ondata(buf) {
    if (buf.length === 0) return;
    if (this.isProcessing) {
      if (buf.length >= this.lengthRemaining) {
        buf = Buffer.concat([...this.buffers, buf]);
        this.buffers = null;
      } else {
        this.buffers.push(buf);
        this.lengthRemaining -= buf.length;
        return;
      }
    } else {
      const length = buf.readInt32LE(0);
      if (buf.length < length - 4) {
        this.isProcessing = true;
        this.lengthRemaining = length - buf.length - 4;
        this.buffers = [buf];
        return;
      }
    }

    this.isProcessing = false;
    const length = buf.readInt32LE(0);
    const data = buf.subarray(4, length + 4);
    const obj = msgpackr.unpack(data);
    if (Object.keys(this.routes).includes(obj.type)) {
      const type = obj.type;
      delete obj.type;
      this.routes[type](obj);
    } else {
      console.log(`Unknown route ${obj.type}`);
    }
    this.ondata(buf.subarray(length + 4));
  }

  discover() {
    this.send({ type: "DISCOVER" });
  }

  send(obj) {
    const data = msgpackr.pack(obj);
    const length = data.length;
    const buf = Buffer.alloc(length + 4);
    buf.writeInt32LE(length, 0);
    data.copy(buf, 4, 0, length);
    this.s.write(buf);
  }

  get(route, handler) {
    this.routes[route] = handler;
  }

  ping() {
    const hrTime = process.hrtime();
    const ns = hrTime[0] * 1000 + hrTime[1] / 1000000;
    this.send({ type: "PING", ns });
  }
  authenticate() {
    let networkInterfaces = os.networkInterfaces();
    delete networkInterfaces.lo;
    this.send({
      type: "AUTH",
      token: this.token,
      hostname: os.hostname(),
      platform: os.platform(),
      localAddress: this.s.localAddress,
      remoteAddress: this.s.remoteAddress,
      // networkInterfaces: networkInterfaces,
    });
  }
  sendText(text) {
    console.log("----", this.receivedText);
    this.send({ type: "CLIP_TEXT", text, name: os.hostname() });
  }

  sendFile(path, otherId) {
    this.send({
      type: "CLIP_FILE",
      file: fs.readFileSync(path),
      fileName: path.split("/").pop(),
      name: os.hostname(),
      otherId,
    });
    console.log("done");
  }
}

module.exports = TCPClient;
