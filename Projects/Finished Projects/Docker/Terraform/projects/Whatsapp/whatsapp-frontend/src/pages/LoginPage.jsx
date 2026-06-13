import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { useAuth } from '../hooks/useAuth'
import { authAPI } from '../services/api'
import {
  Box, Card, TextField, Button, Typography, Container,
  Alert, CircularProgress, Paper, Divider, Link
} from '@mui/material'
import MessageIcon from '@mui/icons-material/Message'

export default function LoginPage() {
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

      login({ id: data.id, username: data.username }, data.token)
      navigate('/chat')
    } catch (err) {
      setError(err.response?.data?.message || 'Authentication failed. Please try again.')
    } finally {
      setLoading(false)
    }
  }

  return (
    <Box
      sx={{
        minHeight: '100vh',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        background: 'linear-gradient(135deg, #0A0E11 0%, #1a1a2e 100%)',
        p: 2,
      }}
    >
      <Container maxWidth="sm">
        <Card
          sx={{
            p: 4,
            backdropFilter: 'blur(10px)',
            backgroundColor: 'rgba(17, 27, 33, 0.8)',
            border: '1px solid rgba(37, 211, 102, 0.2)',
            boxShadow: '0 8px 32px rgba(0, 0, 0, 0.3)',
          }}
        >
          {/* Header */}
          <Box sx={{ textAlign: 'center', mb: 4 }}>
            <Box
              sx={{
                display: 'flex',
                justifyContent: 'center',
                mb: 2,
              }}
            >
              <MessageIcon sx={{ fontSize: 48, color: 'primary.main' }} />
            </Box>
            <Typography variant="h4" sx={{ fontWeight: 700, mb: 1 }}>
              WhatsApp
            </Typography>
            <Typography variant="body2" color="text.secondary">
              {isRegister ? 'Create your account' : 'Sign in to your account'}
            </Typography>
          </Box>

          {/* Error Alert */}
          {error && (
            <Alert severity="error" sx={{ mb: 2 }}>
              {error}
            </Alert>
          )}

          {/* Form */}
          <Box component="form" onSubmit={handleSubmit} sx={{ display: 'flex', flexDirection: 'column', gap: 2 }}>
            <TextField
              label="Username"
              fullWidth
              value={username}
              onChange={(e) => setUsername(e.target.value)}
              disabled={loading}
              sx={{
                '& .MuiOutlinedInput-root': {
                  '&:hover fieldset': {
                    borderColor: 'primary.main',
                  },
                },
              }}
            />
            <TextField
              label="Password"
              type="password"
              fullWidth
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              disabled={loading}
            />

            <Button
              variant="contained"
              color="primary"
              fullWidth
              size="large"
              type="submit"
              disabled={loading || !username || !password}
              sx={{ mt: 1 }}
            >
              {loading ? (
                <CircularProgress size={24} sx={{ color: 'inherit' }} />
              ) : isRegister ? (
                'Create Account'
              ) : (
                'Sign In'
              )}
            </Button>
          </Box>

          {/* Divider */}
          <Divider sx={{ my: 3 }} />

          {/* Toggle */}
          <Box sx={{ textAlign: 'center' }}>
            <Typography variant="body2" color="text.secondary">
              {isRegister ? 'Already have an account?' : "Don't have an account?"}{' '}
              <Link
                component="button"
                variant="body2"
                onClick={(e) => {
                  e.preventDefault()
                  setIsRegister(!isRegister)
                  setError('')
                }}
                sx={{ cursor: 'pointer', color: 'primary.main', fontWeight: 600 }}
              >
                {isRegister ? 'Sign In' : 'Create Account'}
              </Link>
            </Typography>
          </Box>

          {/* Footer */}
          <Typography
            variant="caption"
            sx={{
              display: 'block',
              textAlign: 'center',
              mt: 3,
              color: 'text.secondary',
            }}
          >
            Messages are encrypted end-to-end
          </Typography>
        </Card>
      </Container>
    </Box>
  )
}
