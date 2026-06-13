import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { authAPI } from '../services/api'
import { useAuth } from '../hooks/useAuth'
import { PatternBackground } from '../components/PatternBackground'

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

      login(username, data.token)
      navigate('/chat')
    } catch (err) {
      setError(err.response?.data?.message || 'Authentication failed')
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-whatsapp-dark to-whatsapp-darkBg flex items-center justify-center relative overflow-hidden">
      <PatternBackground isDark={true} />
      
      <div className="w-full max-w-md px-6 relative z-10">
        {/* Logo/Title */}
        <div className="text-center mb-12">
          <div className="inline-block mb-6 p-4 bg-whatsapp-primary/10 rounded-2xl backdrop-blur-sm border border-whatsapp-primary/30">
            <span className="text-5xl">💬</span>
          </div>
          <h1 className="text-5xl font-bold text-whatsapp-primary mb-3">WhatsApp</h1>
          <p className="text-whatsapp-textSecondary text-lg">
            {isRegister ? 'Create your account' : 'Connect with friends'}
          </p>
        </div>

        {/* Card */}
        <div className="bg-whatsapp-lightBg/50 backdrop-blur-xl border border-whatsapp-border/50 rounded-3xl p-8 shadow-2xl">
          {/* Form */}
          <form onSubmit={handleSubmit} className="space-y-5">
            {error && (
              <div className="bg-red-900/40 border border-red-500/50 text-red-300 p-4 rounded-xl text-sm backdrop-blur-sm animate-pulse">
                ⚠️ {error}
              </div>
            )}

            <div>
              <label className="block text-whatsapp-text mb-3 font-semibold text-sm uppercase tracking-wide">
                Username
              </label>
              <input
                type="text"
                value={username}
                onChange={(e) => setUsername(e.target.value)}
                placeholder="Choose a username"
                className="w-full bg-whatsapp-inputBg/80 text-whatsapp-text rounded-xl px-4 py-3 focus:outline-none focus:ring-2 focus:ring-whatsapp-primary/50 border border-whatsapp-border/50 transition placeholder:text-whatsapp-textSecondary/50 backdrop-blur-sm"
                required
              />
            </div>

            <div>
              <label className="block text-whatsapp-text mb-3 font-semibold text-sm uppercase tracking-wide">
                Password
              </label>
              <input
                type="password"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                placeholder="Enter your password"
                className="w-full bg-whatsapp-inputBg/80 text-whatsapp-text rounded-xl px-4 py-3 focus:outline-none focus:ring-2 focus:ring-whatsapp-primary/50 border border-whatsapp-border/50 transition placeholder:text-whatsapp-textSecondary/50 backdrop-blur-sm"
                required
              />
            </div>

            <button
              type="submit"
              disabled={loading}
              className="w-full bg-gradient-to-r from-whatsapp-primary to-green-500 text-black font-bold py-3 rounded-xl hover:shadow-lg hover:shadow-whatsapp-primary/50 disabled:opacity-50 disabled:cursor-not-allowed transition-all duration-300 transform hover:scale-105 mt-6"
            >
              {loading ? (
                <span className="flex items-center justify-center gap-2">
                  <span className="animate-spin">⚡</span> Loading...
                </span>
              ) : isRegister ? (
                '✨ Create Account'
              ) : (
                '🚀 Login'
              )}
            </button>
          </form>

          {/* Divider */}
          <div className="my-6 flex items-center gap-3">
            <div className="flex-1 h-px bg-whatsapp-border/50" />
            <span className="text-whatsapp-textSecondary text-xs uppercase">or</span>
            <div className="flex-1 h-px bg-whatsapp-border/50" />
          </div>

          {/* Toggle */}
          <button
            type="button"
            onClick={() => {
              setIsRegister(!isRegister)
              setError('')
            }}
            className="w-full py-3 px-4 rounded-xl bg-whatsapp-inputBg/50 border border-whatsapp-border/50 text-whatsapp-text font-semibold hover:bg-whatsapp-inputBg/80 transition backdrop-blur-sm"
          >
            {isRegister ? '👤 Already have an account? Login' : '✨ New here? Create Account'}
          </button>
        </div>

        {/* Footer */}
        <p className="text-center text-whatsapp-textSecondary text-xs mt-8">
          Your messages are encrypted end-to-end
        </p>
      </div>
    </div>
  )
}
