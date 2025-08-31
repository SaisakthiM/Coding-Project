const oldLog = console.log;
const oldClear = console.clear;

function sendToServer(message) {
  fetch("/log", {
    method: "POST",
    headers: { "Content-Type": "text/plain" },
    body: message
  }).catch(err => oldLog("Failed to send log:", err));
}

console.log = function (...args) {
  oldLog(...args);          // still show in browser console
  sendToServer(args.join(" "));
};

console.clear = function () {
  oldClear();               // clear browser console
  sendToServer("__CLEAR__"); // tell server to clear terminal
};

// test
console.log("hi");
console.clear();
console.log("after clear");
