const TCPClient = require('./TCPClient');
const fs = require('fs');

const client = new TCPClient('127.0.0.1', 31337);

client.get('PING', (dat) => {
  const hrTime = process.hrtime();
  const ns = hrTime[0] * 1000 + hrTime[1] / 1000000;
  console.log(`Ping: ${(ns - dat.ns).toLocaleString()}ms`);
});

client.get('AUTH_OK', (data) => {
  client.state.auth = true;
  client.state.id = data.id;
  client.discover();
});

client.get('CLIP_TEXT', (dat) => {
  // copy text to the clipboard
  console.log(dat);
});

client.get('CLIP_FILE', (dat) => {
  console.log(dat);

  fs.writeFileSync(dat.fileName, dat.file);
  client.send({ type: 'CLIP_FILE_ENDED', text: 'File Transfer Completed' });
});

client.get('CLIP_FILE_ENDED', (dat) => {
  console.log(dat);
});

client.get('DISCOVER', (dat) => {
  console.log(dat);
});

module.exports = { client };
