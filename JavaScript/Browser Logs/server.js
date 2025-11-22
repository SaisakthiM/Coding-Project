const http = require("http");
const fs = require("fs");
const path = require("path");

const server = http.createServer((req, res) => {
  if (req.method === "POST" && req.url === "/log") {
    let body = "";
    req.on("data", chunk => (body += chunk));
    req.on("end", () => {
      if (body === "__CLEAR__") {
        console.clear();
        console.log("Console was cleared from browser");
      } else {
        console.log("Browser log:", body);
      }
      res.end("ok");
    });
    return;
  }

  // Serve static files (index.html, main.js)
  let filePath = path.join(__dirname, req.url === "/" ? "index.html" : req.url);
  fs.readFile(filePath, (err, data) => {
    if (err) {
      res.writeHead(404);
      res.end("Not found");
    } else {
      res.end(data);
    }
  });
});

server.listen(5500, () => console.log("Server running at http://localhost:5500"));
