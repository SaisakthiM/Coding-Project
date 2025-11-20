import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";

export default {
  server: {
    host: true,
    port: 5173,
    hmr: {
      host: "192.168.1.28",
      protocol: "ws",
      port: 5173
    }
  }
}

