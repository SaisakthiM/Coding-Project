export default function App() {
  return (
    <div className="flex flex-col items-center justify-center h-screen bg-gradient-to-r from-blue-500 to-purple-600 text-white">
      <h1 className="text-5xl font-bold mb-4">Hello, Tailwind!</h1>
      <p className="text-lg bg-white/20 px-4 py-2 rounded-lg">
        🚀 Tailwind is working in React!
      </p>
      <button className="mt-6 px-6 py-2 bg-yellow-400 text-black font-semibold rounded-lg shadow hover:bg-yellow-300 transition">
        Click Me
      </button>
    </div>
  )
}
