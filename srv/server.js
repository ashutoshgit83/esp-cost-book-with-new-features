const cds = require('@sap/cds');
const path = require('path');

cds.on('bootstrap', (app) => {
  const express = require('express');
  // Serve the Fiori application's static files in production
  app.use('/costbookingapp/webapp', express.static(path.join(__dirname, 'app/costbookingapp/webapp')));
});

module.exports = cds.server;
