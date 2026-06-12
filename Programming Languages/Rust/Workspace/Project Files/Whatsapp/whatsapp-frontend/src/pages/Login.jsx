import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { authAPI } from '../services/api'
import { useAuth } from '../hooks/useAuth'

export const Login = () => {
  const [username, setUsername] = useState('')
  const [password, setPassword] = useState('')
  const [isRegister, setIsRegister] = useState(false)
  const [error, setError] = useState('')
  const [loading, setLoading] = useState(false)
  const navigate = useNavigate()
  const { login } = useAuth()

  const handleSubmit = async (e) => {
    e.preventDefault()
    setError('')
    setLoading(true)

    try {
      const { data } = isRegister
        ? await authAPI.register(username, password)
        : await authAPI.login(username, password)

      login({ id: data.id, username }, data.token)
      navigate('/chat')
    } catch (err) {
      setError(err.response?.data?.message || 'Authentication failed')
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-whatsapp-dark to-whatsapp-darkBg flex items-center justify-center">
      <div className="w-full max-w-md">
        {/* Logo/Title */}
        <div className="text-center mb-8">
          <h1 className="text-5xl font-bold text-whatsapp-primary mb-2">WhatsApp</h1>
          <p className="text-whatsapp-textSecondary">
            {isRegister ? 'Create your account' : 'Welcome back'}
          </p>
        </div>

        {/* Form */}
        <form onSubmit={handleSubmit} className="space-y-4">
          {error && (
            <div className="bg-red-900/30 border border-red-500 text-red-400 p-3 rounded-lg text-sm">
              {error}
            </div>
          )}

          <div>
            <label className="block text-whatsapp-text mb-2 font-semibold">Username</label>
            <input
              type="text"
              value={username}
              onChange={(e) => setUsername(e.target.value)}
              placeholder="Enter your username"
              className="w-full bg-whatsapp-inputBg text-whatsapp-text rounded-lg px-4 py-3 focus:outline-none focus:ring-2 focus:ring-whatsapp-primary"
              required
            />
          </div>

          <div>
            <label className="block text-whatsapp-text mb-2 font-semibold">Password</label>
            <input
              type="password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              placeholder="Enter your password"
              className="w-full bg-whatsapp-inputBg text-whatsapp-text rounded-lg px-4 py-3 focus:outline-none focus:ring-2 focus:ring-whatsapp-primary"
              required
            />
          </div>

          <button
            type="submit"
            disabled={loading}
            className="w-full bg-whatsapp-primary text-black font-bold py-3 rounded-lg hover:bg-green-500 disabled:opacity-50 disabled:cursor-not-allowed transition"
          >
            {loading ? 'Loading...' : isRegister ? 'Create Account' : 'Login'}
          </button>
        </form>

        {/* Toggle */}
        <div className="mt-6 text-center">
          <p className="text-whatsapp-textSecondary">
            {isRegister ? 'Already have an account?' : "Don't have an account?"}
            <button
              type="button"
              onClick={() => {
                setIsRegister(!isRegister)
                setError('')
              }}
              className="ml-2 text-whatsapp-primary font-semibold hover:underline"
            >
              {isRegister ? 'Login' : 'Register'}
            </button>
          </p>
        </div>
      </div>
    </div>
  )
}
