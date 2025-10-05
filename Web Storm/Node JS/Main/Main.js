var http = require('http');
var hi = require('./Intro.js');
http.createServer(function (req, res) {
  res.writeHead(200, {'Content-Type': 'application/json'});
  res.end('Hello World!');
}).listen(8080);