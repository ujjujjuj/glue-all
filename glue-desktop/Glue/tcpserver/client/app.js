const { client } = require("./routes");
const { sleep } = require("../utils");

const main = async () => {
  while (true) {
    try {
      await client.connect();
      client.ping();
      // client.authenticate("hello");
      // client.sendText("copy this");

      // process.stdin.on("data", (data) => {
      //   if (data.toString().trim() === "video") {
      //     client.sendFile(path.join(__dirname, "..", "file.txt")); // change here
      //     // client.sendFile("./hello.txt");
      //   } else {
      //     client.sendText(data.toString().trim());
      //   }
      // });

      // client.sendFile();

      await client.waitForDisonnect();
    } catch (e) {
      console.log(e);
      console.log(`[-] Error connecting to the server, retrying...`);
      await sleep(3000);
      client.reinitialize();
    }
  }
};

main();
