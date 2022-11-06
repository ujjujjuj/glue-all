const {
  app,
  BrowserWindow,
  ipcMain,
  Menu,
  Tray,
  MenuItem,
} = require("electron");
const path = require("path");
const isDev = require("electron-is-dev");
const { setwin } = require("./ipcHandlers");

const initialize = async () => {
  mainwin = new BrowserWindow({
    width: 800,
    height: 600,
    webPreferences: {
      preload: path.join(__dirname, "preload.js"),
    },
    title: "Glue Desktop",
  });
  setwin(mainwin);
  mainwin.loadURL(
    isDev
      ? "http://localhost:3000"
      : `file://${path.join(__dirname, "../build/index.html")}`
  );
  mainwin.setMenu(null);
  mainwin.on("close", (e) => {
    if (!app.isQuitting) {
      e.preventDefault();
      mainwin.hide();
    }
  });
  mainwin.setResizable(false);

  let tray = new Tray("icon.png");

  const contextMenu = Menu.buildFromTemplate([
    { label: "Open", click: () => mainwin.show() },
    {
      label: "Exit",
      click: () => {
        app.isQuitting = true;
        app.quit();
      },
    },
  ]);
  contextMenu.insert(
    1,
    new MenuItem({
      label: "Dev Tools",
      click: () => mainwin.webContents.openDevTools({ mode: "detach" }),
    })
  );

  tray.setToolTip("Glue Tooltip");
  tray.setContextMenu(contextMenu);
};

app.whenReady().then(() => {
  initialize();
});

app.on("activate", () => {
  if (BrowserWindow.getAllWindows().length === 0) createWindow();
});
