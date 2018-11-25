/*
const { app } = require('electron');
const execa = require('execa');
const { shell } = require('electron');
const { BrowserWindow } = require('electron');
const path = require('path');

execa.shell('node server.js');

// Enable live reload for Electron too
require('electron-reload')(path.join(__dirname, '/server.js'));

app.on('ready', () => {
  setTimeout(() => {
    const win = new BrowserWindow({ width: 800, height: 600 });
    win.loadURL('http://127.0.0.1:9000');
  }, 4000);
});
*/
