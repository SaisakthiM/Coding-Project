import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react-swc'

const devHost = process.env.VITE_DEV_SERVER_HOST || 'localhost'

export default defineConfig({
  plugins: [react()],
  server: {
    host: true,            // listen on all network interfaces inside container
    port: 5173,
    strictPort: true,
    hmr: {
      host: devHost,       // what the browser will connect to
      port: 5173,
    },
    watch: {
      usePolling: true,    // ensures file changes are detected in Docker
      interval: 100,
    },
  },
})
