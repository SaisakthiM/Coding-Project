import React, { useState, useEffect } from 'react';
import {
  ThemeProvider,
  createTheme,
  CssBaseline,
  AppBar,
  Toolbar,
  Typography,
  Container,
  Box,
  Card,
  CardHeader,
  CardContent,
  CardActions,
  CardMedia,
  Avatar,
  IconButton,
  TextField,
  Button,
  Fab,
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
  Drawer,
  List,
  ListItem,
  ListItemIcon,
  ListItemText,
  Divider,
  Badge,
  Menu,
  MenuItem,
  Tabs,
  Tab,
  Grid,
  Paper,
  Chip,
  CircularProgress,
  Snackbar,
  Alert,
  InputAdornment,
} from '@mui/material';
import {
  Favorite,
  FavoriteBorder,
  Comment,
  Share,
  Add,
  Home,
  Person,
  Notifications,
  Settings,
  Logout,
  Search,
  Image,
  Send,
  MoreVert,
  Close,
  Menu as MenuIcon,
} from '@mui/icons-material';

const theme = createTheme({
  palette: {
    mode: 'light',
    primary: {
      main: '#1976d2',
    },
    secondary: {
      main: '#dc004e',
    },
  },
});

function App() {
  const [user, setUser] = useState(null);
  const [posts, setPosts] = useState([]);
  const [view, setView] = useState('feed');
  const [drawerOpen, setDrawerOpen] = useState(false);
  const [createPostOpen, setCreatePostOpen] = useState(false);
  const [newPost, setNewPost] = useState({ content: '', image: null });
  const [imagePreview, setImagePreview] = useState(null);
  const [anchorEl, setAnchorEl] = useState(null);
  const [notifications, setNotifications] = useState([]);
  const [notifAnchor, setNotifAnchor] = useState(null);
  const [loading, setLoading] = useState(false);
  const [snackbar, setSnackbar] = useState({ open: false, message: '', severity: 'success' });
  const [loginForm, setLoginForm] = useState({ username: '', password: '' });
  const [registerForm, setRegisterForm] = useState({ username: '', email: '', password: '' });
  const [authView, setAuthView] = useState('login');

  // Mock data for demonstration
  useEffect(() => {
    if (user) {
      setPosts([
        {
          id: 1,
          author: { name: 'John Doe', avatar: 'JD' },
          content: 'Just deployed my microservices architecture! 🚀 Using Java Spring Boot and Go for different services.',
          image: null,
          likes: 24,
          comments: 5,
          liked: false,
          timestamp: '2 hours ago',
        },
        {
          id: 2,
          author: { name: 'Jane Smith', avatar: 'JS' },
          content: 'Beautiful sunset today! #nature #photography',
          image: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400',
          likes: 89,
          comments: 12,
          liked: true,
          timestamp: '4 hours ago',
        },
        {
          id: 3,
          author: { name: 'Tech Explorer', avatar: 'TE' },
          content: 'Learning about observability with Prometheus and Grafana. The insights are amazing! 📊',
          image: null,
          likes: 45,
          comments: 8,
          liked: false,
          timestamp: '6 hours ago',
        },
      ]);
      setNotifications([
        { id: 1, text: 'John Doe liked your post', time: '10m ago', read: false },
        { id: 2, text: 'Jane Smith commented on your post', time: '1h ago', read: false },
        { id: 3, text: 'New follower: Tech Explorer', time: '3h ago', read: true },
      ]);
    }
  }, [user]);

  const handleLogin = (e) => {
    e.preventDefault();
    setLoading(true);
    // Simulate API call
    setTimeout(() => {
      setUser({
        id: 1,
        name: loginForm.username,
        email: 'user@example.com',
        avatar: loginForm.username.substring(0, 2).toUpperCase(),
      });
      setLoading(false);
      setSnackbar({ open: true, message: 'Login successful!', severity: 'success' });
    }, 1000);
  };

  const handleRegister = (e) => {
    e.preventDefault();
    setLoading(true);
    setTimeout(() => {
      setUser({
        id: 1,
        name: registerForm.username,
        email: registerForm.email,
        avatar: registerForm.username.substring(0, 2).toUpperCase(),
      });
      setLoading(false);
      setSnackbar({ open: true, message: 'Registration successful!', severity: 'success' });
    }, 1000);
  };

  const handleLogout = () => {
    setUser(null);
    setView('feed');
    setDrawerOpen(false);
    setSnackbar({ open: true, message: 'Logged out successfully', severity: 'info' });
  };

  const handleCreatePost = () => {
    if (!newPost.content.trim()) return;
    
    setLoading(true);
    setTimeout(() => {
      const post = {
        id: posts.length + 1,
        author: { name: user.name, avatar: user.avatar },
        content: newPost.content,
        image: imagePreview,
        likes: 0,
        comments: 0,
        liked: false,
        timestamp: 'Just now',
      };
      setPosts([post, ...posts]);
      setNewPost({ content: '', image: null });
      setImagePreview(null);
      setCreatePostOpen(false);
      setLoading(false);
      setSnackbar({ open: true, message: 'Post created!', severity: 'success' });
    }, 500);
  };

  const handleImageUpload = (e) => {
    const file = e.target.files[0];
    if (file) {
      const reader = new FileReader();
      reader.onloadend = () => {
        setImagePreview(reader.result);
        setNewPost({ ...newPost, image: file });
      };
      reader.readAsDataURL(file);
    }
  };

  const handleLike = (postId) => {
    setPosts(posts.map(post => {
      if (post.id === postId) {
        return {
          ...post,
          liked: !post.liked,
          likes: post.liked ? post.likes - 1 : post.likes + 1,
        };
      }
      return post;
    }));
  };

  // Authentication View
  if (!user) {
    return (
      <ThemeProvider theme={theme}>
        <CssBaseline />
        <Box
          sx={{
            minHeight: '100vh',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
          }}
        >
          <Container maxWidth="sm">
            <Card sx={{ p: 4 }}>
              <Box sx={{ textAlign: 'center', mb: 3 }}>
                <Avatar sx={{ width: 80, height: 80, margin: '0 auto', mb: 2, bgcolor: 'primary.main' }}>
                  <Home sx={{ fontSize: 40 }} />
                </Avatar>
                <Typography variant="h4" gutterBottom fontWeight="bold">
                  Social Connect
                </Typography>
                <Typography variant="body2" color="text.secondary">
                  Connect with friends and the world around you
                </Typography>
              </Box>

              <Tabs value={authView} onChange={(e, v) => setAuthView(v)} sx={{ mb: 3 }}>
                <Tab label="Login" value="login" sx={{ flex: 1 }} />
                <Tab label="Register" value="register" sx={{ flex: 1 }} />
              </Tabs>

              {authView === 'login' ? (
                <form onSubmit={handleLogin}>
                  <TextField
                    fullWidth
                    label="Username"
                    margin="normal"
                    value={loginForm.username}
                    onChange={(e) => setLoginForm({ ...loginForm, username: e.target.value })}
                    required
                  />
                  <TextField
                    fullWidth
                    type="password"
                    label="Password"
                    margin="normal"
                    value={loginForm.password}
                    onChange={(e) => setLoginForm({ ...loginForm, password: e.target.value })}
                    required
                  />
                  <Button
                    fullWidth
                    variant="contained"
                    size="large"
                    type="submit"
                    sx={{ mt: 3 }}
                    disabled={loading}
                  >
                    {loading ? <CircularProgress size={24} /> : 'Login'}
                  </Button>
                </form>
              ) : (
                <form onSubmit={handleRegister}>
                  <TextField
                    fullWidth
                    label="Username"
                    margin="normal"
                    value={registerForm.username}
                    onChange={(e) => setRegisterForm({ ...registerForm, username: e.target.value })}
                    required
                  />
                  <TextField
                    fullWidth
                    type="email"
                    label="Email"
                    margin="normal"
                    value={registerForm.email}
                    onChange={(e) => setRegisterForm({ ...registerForm, email: e.target.value })}
                    required
                  />
                  <TextField
                    fullWidth
                    type="password"
                    label="Password"
                    margin="normal"
                    value={registerForm.password}
                    onChange={(e) => setRegisterForm({ ...registerForm, password: e.target.value })}
                    required
                  />
                  <Button
                    fullWidth
                    variant="contained"
                    size="large"
                    type="submit"
                    sx={{ mt: 3 }}
                    disabled={loading}
                  >
                    {loading ? <CircularProgress size={24} /> : 'Register'}
                  </Button>
                </form>
              )}
            </Card>
          </Container>
        </Box>
      </ThemeProvider>
    );
  }

  // Main App View
  return (
    <ThemeProvider theme={theme}>
      <CssBaseline />
      <Box sx={{ display: 'flex', flexDirection: 'column', minHeight: '100vh' }}>
        {/* AppBar */}
        <AppBar position="sticky">
          <Toolbar>
            <IconButton
              edge="start"
              color="inherit"
              onClick={() => setDrawerOpen(true)}
              sx={{ mr: 2, display: { md: 'none' } }}
            >
              <MenuIcon />
            </IconButton>
            <Typography variant="h6" sx={{ flexGrow: 1, fontWeight: 'bold' }}>
              Social Connect
            </Typography>
            <TextField
              size="small"
              placeholder="Search..."
              sx={{
                display: { xs: 'none', sm: 'block' },
                mr: 2,
                bgcolor: 'rgba(255,255,255,0.15)',
                borderRadius: 1,
                '& .MuiOutlinedInput-root': { color: 'white' },
              }}
              InputProps={{
                startAdornment: (
                  <InputAdornment position="start">
                    <Search sx={{ color: 'white' }} />
                  </InputAdornment>
                ),
              }}
            />
            <IconButton color="inherit" onClick={(e) => setNotifAnchor(e.currentTarget)}>
              <Badge badgeContent={notifications.filter(n => !n.read).length} color="error">
                <Notifications />
              </Badge>
            </IconButton>
            <IconButton color="inherit" onClick={(e) => setAnchorEl(e.currentTarget)}>
              <Avatar sx={{ width: 32, height: 32 }}>{user.avatar}</Avatar>
            </IconButton>
          </Toolbar>
        </AppBar>

        {/* User Menu */}
        <Menu anchorEl={anchorEl} open={Boolean(anchorEl)} onClose={() => setAnchorEl(null)}>
          <MenuItem onClick={() => { setView('profile'); setAnchorEl(null); }}>
            <ListItemIcon><Person /></ListItemIcon>
            Profile
          </MenuItem>
          <MenuItem onClick={() => setAnchorEl(null)}>
            <ListItemIcon><Settings /></ListItemIcon>
            Settings
          </MenuItem>
          <Divider />
          <MenuItem onClick={handleLogout}>
            <ListItemIcon><Logout /></ListItemIcon>
            Logout
          </MenuItem>
        </Menu>

        {/* Notifications Menu */}
        <Menu anchorEl={notifAnchor} open={Boolean(notifAnchor)} onClose={() => setNotifAnchor(null)}>
          <Box sx={{ p: 2, minWidth: 300 }}>
            <Typography variant="h6" gutterBottom>Notifications</Typography>
          </Box>
          <Divider />
          {notifications.map(notif => (
            <MenuItem key={notif.id} sx={{ whiteSpace: 'normal' }}>
              <Box>
                <Typography variant="body2">{notif.text}</Typography>
                <Typography variant="caption" color="text.secondary">{notif.time}</Typography>
              </Box>
            </MenuItem>
          ))}
        </Menu>

        {/* Drawer for mobile */}
        <Drawer anchor="left" open={drawerOpen} onClose={() => setDrawerOpen(false)}>
          <Box sx={{ width: 250 }}>
            <Box sx={{ p: 2, textAlign: 'center' }}>
              <Avatar sx={{ width: 64, height: 64, margin: '0 auto', mb: 1 }}>
                {user.avatar}
              </Avatar>
              <Typography variant="h6">{user.name}</Typography>
              <Typography variant="body2" color="text.secondary">{user.email}</Typography>
            </Box>
            <Divider />
            <List>
              <ListItem button onClick={() => { setView('feed'); setDrawerOpen(false); }}>
                <ListItemIcon><Home /></ListItemIcon>
                <ListItemText primary="Feed" />
              </ListItem>
              <ListItem button onClick={() => { setView('profile'); setDrawerOpen(false); }}>
                <ListItemIcon><Person /></ListItemIcon>
                <ListItemText primary="Profile" />
              </ListItem>
            </List>
          </Box>
        </Drawer>

        {/* Main Content */}
        <Container maxWidth="md" sx={{ flex: 1, py: 3 }}>
          {view === 'feed' && (
            <Box>
              {/* Create Post Card */}
              <Card sx={{ mb: 3 }}>
                <CardContent>
                  <Box sx={{ display: 'flex', gap: 2 }}>
                    <Avatar>{user.avatar}</Avatar>
                    <TextField
                      fullWidth
                      placeholder={`What's on your mind, ${user.name}?`}
                      variant="outlined"
                      onClick={() => setCreatePostOpen(true)}
                      sx={{ cursor: 'pointer' }}
                    />
                  </Box>
                </CardContent>
              </Card>

              {/* Posts Feed */}
              {posts.map(post => (
                <Card key={post.id} sx={{ mb: 3 }}>
                  <CardHeader
                    avatar={<Avatar>{post.author.avatar}</Avatar>}
                    action={
                      <IconButton>
                        <MoreVert />
                      </IconButton>
                    }
                    title={post.author.name}
                    subheader={post.timestamp}
                  />
                  <CardContent>
                    <Typography variant="body1">{post.content}</Typography>
                  </CardContent>
                  {post.image && (
                    <CardMedia component="img" height="300" image={post.image} alt="Post" />
                  )}
                  <CardActions disableSpacing>
                    <IconButton onClick={() => handleLike(post.id)}>
                      {post.liked ? <Favorite color="error" /> : <FavoriteBorder />}
                    </IconButton>
                    <Typography variant="body2" sx={{ mr: 2 }}>{post.likes}</Typography>
                    <IconButton>
                      <Comment />
                    </IconButton>
                    <Typography variant="body2" sx={{ mr: 2 }}>{post.comments}</Typography>
                    <IconButton sx={{ ml: 'auto' }}>
                      <Share />
                    </IconButton>
                  </CardActions>
                </Card>
              ))}
            </Box>
          )}

          {view === 'profile' && (
            <Box>
              <Card sx={{ mb: 3 }}>
                <CardContent>
                  <Box sx={{ textAlign: 'center', py: 3 }}>
                    <Avatar sx={{ width: 120, height: 120, margin: '0 auto', mb: 2, fontSize: 48 }}>
                      {user.avatar}
                    </Avatar>
                    <Typography variant="h4" gutterBottom>{user.name}</Typography>
                    <Typography variant="body1" color="text.secondary" gutterBottom>
                      {user.email}
                    </Typography>
                    <Box sx={{ display: 'flex', justifyContent: 'center', gap: 4, mt: 3 }}>
                      <Box>
                        <Typography variant="h6">128</Typography>
                        <Typography variant="body2" color="text.secondary">Posts</Typography>
                      </Box>
                      <Box>
                        <Typography variant="h6">1.2K</Typography>
                        <Typography variant="body2" color="text.secondary">Followers</Typography>
                      </Box>
                      <Box>
                        <Typography variant="h6">856</Typography>
                        <Typography variant="body2" color="text.secondary">Following</Typography>
                      </Box>
                    </Box>
                  </Box>
                </CardContent>
              </Card>

              <Typography variant="h6" gutterBottom>Your Posts</Typography>
              <Grid container spacing={2}>
                {posts.filter(p => p.author.name === user.name).map(post => (
                  <Grid item xs={12} sm={6} key={post.id}>
                    <Card>
                      {post.image && <CardMedia component="img" height="200" image={post.image} />}
                      <CardContent>
                        <Typography variant="body2">{post.content}</Typography>
                        <Box sx={{ display: 'flex', gap: 2, mt: 1 }}>
                          <Chip size="small" icon={<Favorite />} label={post.likes} />
                          <Chip size="small" icon={<Comment />} label={post.comments} />
                        </Box>
                      </CardContent>
                    </Card>
                  </Grid>
                ))}
              </Grid>
            </Box>
          )}
        </Container>

        {/* Create Post Dialog */}
        <Dialog open={createPostOpen} onClose={() => setCreatePostOpen(false)} maxWidth="sm" fullWidth>
          <DialogTitle>
            Create Post
            <IconButton
              onClick={() => setCreatePostOpen(false)}
              sx={{ position: 'absolute', right: 8, top: 8 }}
            >
              <Close />
            </IconButton>
          </DialogTitle>
          <DialogContent>
            <Box sx={{ display: 'flex', gap: 2, mb: 2 }}>
              <Avatar>{user.avatar}</Avatar>
              <Typography variant="subtitle1">{user.name}</Typography>
            </Box>
            <TextField
              fullWidth
              multiline
              rows={4}
              placeholder="What's on your mind?"
              value={newPost.content}
              onChange={(e) => setNewPost({ ...newPost, content: e.target.value })}
              sx={{ mb: 2 }}
            />
            {imagePreview && (
              <Box sx={{ position: 'relative', mb: 2 }}>
                <img src={imagePreview} alt="Preview" style={{ width: '100%', borderRadius: 8 }} />
                <IconButton
                  sx={{ position: 'absolute', top: 8, right: 8, bgcolor: 'rgba(0,0,0,0.5)' }}
                  onClick={() => { setImagePreview(null); setNewPost({ ...newPost, image: null }); }}
                >
                  <Close sx={{ color: 'white' }} />
                </IconButton>
              </Box>
            )}
            <Button
              variant="outlined"
              component="label"
              startIcon={<Image />}
              fullWidth
            >
              Add Photo
              <input type="file" hidden accept="image/*" onChange={handleImageUpload} />
            </Button>
          </DialogContent>
          <DialogActions sx={{ p: 2 }}>
            <Button onClick={() => setCreatePostOpen(false)}>Cancel</Button>
            <Button
              variant="contained"
              onClick={handleCreatePost}
              disabled={!newPost.content.trim() || loading}
              startIcon={loading ? <CircularProgress size={16} /> : <Send />}
            >
              Post
            </Button>
          </DialogActions>
        </Dialog>

        {/* Floating Action Button */}
        <Fab
          color="primary"
          sx={{ position: 'fixed', bottom: 16, right: 16 }}
          onClick={() => setCreatePostOpen(true)}
        >
          <Add />
        </Fab>

        {/* Snackbar */}
        <Snackbar
          open={snackbar.open}
          autoHideDuration={3000}
          onClose={() => setSnackbar({ ...snackbar, open: false })}
        >
          <Alert severity={snackbar.severity}>{snackbar.message}</Alert>
        </Snackbar>
      </Box>
    </ThemeProvider>
  );
}

export default App;