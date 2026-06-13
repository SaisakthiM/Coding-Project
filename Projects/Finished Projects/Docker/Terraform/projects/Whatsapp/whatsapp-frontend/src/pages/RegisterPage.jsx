import { useState } from 'react'
import { useNavigate, Link } from 'react-router-dom'
import { useAuthStore } from '../store/authStore'

export default function RegisterPage() {
  const navigate = useNavigate()
  const [username, setUsername] = useState('')
  const [password, setPassword] = useState('')
  const [confirmPassword, setConfirmPassword] = useState('')
  const [passwordError, setPasswordError] = useState('')
  const { register, isLoading, error, clearError } = useAuthStore()

  const handleSubmit = async (e) => {
    e.preventDefault()
    clearError()
    setPasswordError('')

    if (password !== confirmPassword) {
      setPasswordError('Passwords do not match')
      return
    }

    if (password.length < 6) {
      setPasswordError('Password must be at least 6 characters')
      return
    }

    try {
      await register(username, password)
      navigate('/')
    } catch (err) {
      // Error handled in store
    }
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-whatsapp-green to-green-500 flex items-center justify-center p-4">
      <div className="w-full max-w-md">
        {/* Logo Section */}
        <div className="text-center mb-8">
          <div className="inline-flex items-center justify-center w-16 h-16 bg-white rounded-full mb-4">
            <svg className="w-10 h-10 text-whatsapp-green" fill="currentColor" viewBox="0 0 24 24">
              <path d="M17.472 14.382c-.297-.149-1.758-.867-2.03-.967-.273-.099-.471-.148-.67.15-.197.297-.767.966-.94 1.164-.173.199-.347.223-.644.075-.297-.149-1.255-.463-2.39-1.475-.883-.788-1.48-1.761-1.653-2.059-.173-.297-.018-.458.13-.606.134-.133.298-.347.446-.52.149-.174.198-.298.298-.497.099-.198.05-.371-.025-.52-.075-.149-.669-1.612-.916-2.207-.242-.579-.487-.5-.67-.51-.173-.008-.371-.01-.57-.01-.198 0-.52.074-.792.372-.272.297-1.04 1.016-1.04 2.479 0 1.462 1.065 2.875 1.213 3.074.149.198 2.096 3.2 5.076 4.487.709.306 1.262.489 1.694.625.712.227 1.36.195 1.871.118.571-.085 1.758-.719 2.006-1.413.248-.694.248-1.289.173-1.413-.074-.124-.272-.198-.57-.347m-5.421-7.403h-.004a9.87 9.87 0 00-5.031 1.378c-3.055 2.086-5.053 5.409-5.053 9.009 0 3.182.824 6.329 2.372 9.019l-2.52 9.021 9.267-3.286c2.592 1.874 5.814 2.777 9.26 2.777h.005c8.242 0 14.288-6.352 14.288-14.29C21.722 7.9 15.675 1.6 7.365 1.6z"/>
            </svg>
          </div>
          <h1 className="text-4xl font-bold text-white mb-2">WhatsApp</h1>
          <p className="text-white/80">Create your account</p>
        </div>

        {/* Register Form */}
        <div className="card p-8 space-y-6">
          <form onSubmit={handleSubmit} className="space-y-4">
            <div>
              <label className="block text-sm font-medium text-whatsapp-dark mb-2">
                Username
              </label>
              <input
                type="text"
                value={username}
                onChange={(e) => setUsername(e.target.value)}
                placeholder="Choose a username"
                className="input-field"
                required
                disabled={isLoading}
              />
            </div>

            <div>
              <label className="block text-sm font-medium text-whatsapp-dark mb-2">
                Password
              </label>
              <input
                type="password"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                placeholder="At least 6 characters"
                className="input-field"
                required
                disabled={isLoading}
              />
            </div>

            <div>
              <label className="block text-sm font-medium text-whatsapp-dark mb-2">
                Confirm Password
              </label>
              <input
                type="password"
                value={confirmPassword}
                onChange={(e) => setConfirmPassword(e.target.value)}
                placeholder="Confirm your password"
                className="input-field"
                required
                disabled={isLoading}
              />
            </div>

            {error && (
              <div className="bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded-lg text-sm">
                {error}
              </div>
            )}

            {passwordError && (
              <div className="bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded-lg text-sm">
                {passwordError}
              </div>
            )}

            <button
              type="submit"
              disabled={isLoading}
              className="btn-primary w-full"
            >
              {isLoading ? 'Creating account...' : 'Register'}
            </button>
          </form>

          <div className="divider"></div>

          <div className="text-center">
            <p className="text-whatsapp-gray text-sm">
              Already have an account?{' '}
              <Link to="/login" className="text-whatsapp-green font-semibold hover:underline">
                Login here
              </Link>
            </p>
          </div>
        </div>
      </div>
    </div>
  )
}
