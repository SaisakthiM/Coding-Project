import { useState, useEffect } from 'react'
import { useNavigate } from 'react-router-dom'
import { useAuth } from '../hooks/useAuth'
import { authAPI, fileAPI } from '../services/api'
import {
  Box, Container, Card, TextField, Button, Avatar,
  Typography, Paper, Grid, Alert, CircularProgress,
  Switch, FormControlLabel
} from '@mui/material'
import ArrowBackIcon from '@mui/icons-material/ArrowBack'
import SaveIcon from '@mui/icons-material/Save'

export default function ProfilePage() {
  const navigate = useNavigate()
  const { user } = useAuth()
  const [profile, setProfile] = useState(null)
  const [settings, setSettings] = useState(null)
  const [username, setUsername] = useState('')
  const [bio, setBio] = useState('')
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState('')
  const [success, setSuccess] = useState('')

  useEffect(() => {
    loadProfile()
    loadSettings()
  }, [user])

  const loadProfile = async () => {
    try {
      const { data } = await authAPI.getProfile(user.id)
      setProfile(data)
      setUsername(data.username)
      setBio(data.bio || '')
    } catch (err) {
      setError('Failed to load profile')
    }
  }

  const loadSettings = async () => {
    try {
      const { data } = await authAPI.getSettings(user.id)
      setSettings(data)
    } catch (err) {
      console.error('Failed to load settings:', err)
    }
  }

  const handleSaveProfile = async () => {
    setLoading(true)
    try {
      await authAPI.updateProfile(user.id, { username, bio })
      setSuccess('Profile updated successfully')
      setTimeout(() => setSuccess(''), 3000)
    } catch (err) {
      setError('Failed to update profile')
    } finally {
      setLoading(false)
    }
  }

  const handleSaveSettings = async () => {
    setLoading(true)
    try {
      await authAPI.updateSettings(user.id, settings)
      setSuccess('Settings updated successfully')
      setTimeout(() => setSuccess(''), 3000)
    } catch (err) {
      setError('Failed to update settings')
    } finally {
      setLoading(false)
    }
  }

  if (!profile || !settings) {
    return (
      <Box sx={{ display: 'flex', justifyContent: 'center', alignItems: 'center', minHeight: '100vh' }}>
        <CircularProgress />
      </Box>
    )
  }

  return (
    <Box sx={{ minHeight: '100vh', pt: 10, pb: 4 }}>
      <Container maxWidth="md">
        {/* Back Button */}
        <Button startIcon={<ArrowBackIcon />} onClick={() => navigate('/chat')} sx={{ mb: 3 }}>
          Back to Chat
        </Button>

        {/* Alerts */}
        {error && <Alert severity="error" sx={{ mb: 2 }}>{error}</Alert>}
        {success && <Alert severity="success" sx={{ mb: 2 }}>{success}</Alert>}

        {/* Profile Card */}
        <Card sx={{ p: 3, mb: 3 }}>
          <Typography variant="h5" sx={{ mb: 3 }}>Profile Information</Typography>
          <Grid container spacing={3}>
            <Grid item xs={12} sm={4} sx={{ textAlign: 'center' }}>
              <Avatar
                sx={{ width: 120, height: 120, mx: 'auto', mb: 2, backgroundColor: 'primary.main' }}
                src={profile.avatar_url}
              >
                {username.charAt(0).toUpperCase()}
              </Avatar>
            </Grid>
            <Grid item xs={12} sm={8}>
              <TextField
                fullWidth
                label="Username"
                value={username}
                onChange={(e) => setUsername(e.target.value)}
                sx={{ mb: 2 }}
              />
              <TextField
                fullWidth
                label="Bio"
                multiline
                rows={3}
                value={bio}
                onChange={(e) => setBio(e.target.value)}
                sx={{ mb: 2 }}
              />
              <Button
                variant="contained"
                color="primary"
                startIcon={<SaveIcon />}
                onClick={handleSaveProfile}
                disabled={loading}
              >
                Save Profile
              </Button>
            </Grid>
          </Grid>
        </Card>

        {/* Settings Card */}
        <Card sx={{ p: 3 }}>
          <Typography variant="h5" sx={{ mb: 3 }}>Settings</Typography>
          <Box sx={{ display: 'flex', flexDirection: 'column', gap: 2 }}>
            <FormControlLabel
              control={
                <Switch
                  checked={settings.notification_enabled}
                  onChange={(e) => setSettings({ ...settings, notification_enabled: e.target.checked })}
                />
              }
              label="Enable Notifications"
            />
            <TextField
              label="Theme"
              select
              value={settings.theme}
              onChange={(e) => setSettings({ ...settings, theme: e.target.value })}
              SelectProps={{ native: true }}
            >
              <option value="dark">Dark</option>
              <option value="light">Light</option>
            </TextField>
            <TextField
              label="Language"
              select
              value={settings.language}
              onChange={(e) => setSettings({ ...settings, language: e.target.value })}
              SelectProps={{ native: true }}
            >
              <option value="en">English</option>
              <option value="es">Spanish</option>
              <option value="fr">French</option>
            </TextField>
            <Button
              variant="contained"
              color="primary"
              startIcon={<SaveIcon />}
              onClick={handleSaveSettings}
              disabled={loading}
            >
              Save Settings
            </Button>
          </Box>
        </Card>
      </Container>
    </Box>
  )
}
