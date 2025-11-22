import { defineConfig } from "vite";
import react from "react";

export default defineConfig({

  server: {
    host: "0.0.0.0",          // listen on all network interfaces
    port: 5173,                // dev server port
    strictPort: true,          // fail if port is in use
    hmr: {
      protocol: "ws",          // use WebSocket
      host: "192.168.1.28",   // your local LAN IP
      port: 5173,              // match the dev server port
    },
  },
});
