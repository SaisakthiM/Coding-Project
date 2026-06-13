/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,jsx}"
  ],
  theme: {
    extend: {
      colors: {
        whatsapp: {
          green: '#25D366',
          dark: '#111B21',
          darker: '#0A0E11',
          light: '#F0F2F5',
          lighter: '#FFFFFF',
          gray: '#54656F',
          border: '#E5E7EB',
          bg: '#ECE5DD'
        }
      },
      fontFamily: {
        sans: ['Segoe UI', 'Helvetica Neue', 'sans-serif']
      }
    }
  },
  plugins: []
}
