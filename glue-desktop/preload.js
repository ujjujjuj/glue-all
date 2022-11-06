const { contextBridge, ipcRenderer } = require("electron");
// const { client } = require("./protoclient/routes.js");

contextBridge.exposeInMainWorld("versions", {
  node: process.versions.node,
  chrome: process.versions.chrome,
  electron: process.versions.electron,
});

contextBridge.exposeInMainWorld("ipc", {
  invoke: ipcRenderer.invoke,
  on: ipcRenderer.on,
  // token: () => client.token,
});
