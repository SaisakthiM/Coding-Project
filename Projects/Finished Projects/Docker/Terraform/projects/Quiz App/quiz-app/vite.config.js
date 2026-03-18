import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react-swc'

export default defineConfig({
  base: '/quiz/',
  plugins: [react()],
  server: {
    host: true,
    port: 5173,
  }
})
