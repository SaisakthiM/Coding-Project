import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';   // ← NOT plugin-react-swc

const cssStubPlugin = {
  name: 'css-stub',
  enforce: 'pre',
  resolveId(id) {
    if (id.endsWith('.css')) return id;
  },
  load(id) {
    if (id.endsWith('.css')) return 'export default {}';
  },
};

export default defineConfig({
  base: '/quiz/',
  plugins: [react(), cssStubPlugin],
  server: {
    host: true,
    port: 5173,
  },
  test: {
    environment: 'jsdom',
    globals: true,
    setupFiles: ['./src/setupTests.js'],
  },
});