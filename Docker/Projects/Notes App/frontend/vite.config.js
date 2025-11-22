// vite.config.js
import { defineConfig } from "vite";
import react from "@vitejs/plugin-react-swc";

export default defineConfig({
  plugins: [react()],
  server: {
    host: true, // allows access via LAN / Docker network
    port: 5173,
    hmr: {
      protocol: "ws",
      host: "localhost", // or your host IP if accessing from other device
      port: 5173,
    },
  },
});
