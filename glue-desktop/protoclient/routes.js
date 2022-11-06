const TCPClient = require("./TCPClient");
const fs = require("fs");

const client = new TCPClient("192.168.196.25", 31337);
let clipboardy = null;
import("clipboardy").then((mod) => (clipboardy = mod.default));
const downloadsFolder = require("downloads-folder");
const path = require("path");
const os = require("os");
const { Notification } = require("electron");

client.get("PONG", (dat) => {
  const hrTime = process.hrtime();
  const ns = hrTime[0] * 1000 + hrTime[1] / 1000000;
  console.log(`Ping: ${(ns - dat.ns).toLocaleString()}ms`);
});

client.get("AUTH_OK", (data) => {
  client.state.auth = true;
  client.state.id = data.id;
  client.discover();
});

client.get("CLIP_TEXT", (dat) => {
  client.receivedText = dat.text;
  clipboardy.writeSync(dat.text);
  console.log(dat);
  new Notification({
    title: "Copied Clipboard",
    body: `Received text ${dat.text} from ${dat.name}`,
  }).show();
  // client.mainwin.webContents.send("file", { text: dat.text, name: dat.name });
});

client.get("CLIP_FILE", (dat) => {
  console.log(dat);
  fs.writeFileSync(path.join(downloadsFolder(), dat.fileName), dat.file);
  client.send({ type: "CLIP_FILE_ENDED", text: "File Transfer Completed" });
  new Notification({
    title: "File received",
    body: `Received ${dat.fileName} from ${dat.name}`,
  }).show();
  // client.mainwin.webContents.send("file", {
  //   fileName: dat.fileName,
  //   name: dat.name,
  // });
});

client.get("CLIP_FILE_ENDED", (dat) => {
  console.log("file ended", dat);
});

client.get("DISCOVER", (dat) => {
  console.log("discover", dat);
});

module.exports = { client };
