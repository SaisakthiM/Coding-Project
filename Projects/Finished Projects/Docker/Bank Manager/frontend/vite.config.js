import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react-swc'

// https://vite.dev/config/
export default defineConfig({
  plugins: [react()],
  server: {
    host: '0.0.0.0',        // Listen on all interfaces (required for Docker)
    port: 3000,
    strictPort: true,       // Exit if port is already in use
    watch: {
      usePolling: true,     // Required for HMR in Docker
      interval: 100         // Polling interval
    },
    hmr: {
      clientPort: 3000      // HMR WebSocket port
    },
    proxy: {
      '/api': {
        target: 'http://backend:8080',
        changeOrigin: true,
        secure: false
      }
    }
  }
})