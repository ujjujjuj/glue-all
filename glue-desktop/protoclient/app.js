const { client } = require("./routes");
const { sleep } = require("../utils");
let isStarted = false;

const start = async () => {
  if (isStarted) return;
  isStarted = true;
  while (true) {
    try {
      await client.connect();
      
      client.ping();
      client.authenticate();
      await client.waitForDisonnect();
    } catch (e) {
      console.log(e);
      console.log(`[-] Error connecting to the server, retrying...`);
      await sleep(3000);
      client.reinitialize();
    }
    isStarted = false;
  }
};

module.exports = { start };
