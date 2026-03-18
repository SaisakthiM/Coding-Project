#!/bin/bash
set -e

FRONTEND="/home/saisakthi/Coding-Project/Projects/Finished Projects/Docker/Terraform/projects/Bank Manager/frontend/src"

# ─── LOGIN ────────────────────────────────────────────────────────────────────
cat > "$FRONTEND/components/Login.jsx" << 'EOF'
import { useState } from "react"
import { useNavigate } from "react-router-dom"
import { useAuth } from "../context/AuthContext"
import axios from "axios"

export default function Login() {
  const [username, setUsername] = useState("")
  const [password, setPassword] = useState("")
  const [error, setError] = useState("")
  const [loading, setLoading] = useState(false)
  const { login } = useAuth()
  const navigate = useNavigate()

  async function handleLogin() {
    setLoading(true)
    setError("")
    try {
      const res = await axios.post("/bank/api/auth/login", { username, password })
      if (res.data.success) {
        login(res.data.data)
        navigate("/")
      } else {
        setError(res.data.message)
      }
    } catch (err) {
      setError(err.response?.data?.message || "Login failed")
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="wrapper">
      <div className="container">
        <h1>Bank Manager</h1>
        <h3>Login to your account</h3>
        <div className="form-group">
          <label>Username</label>
          <input type="text" placeholder="Enter username" value={username}
            onChange={e => setUsername(e.target.value)} />
        </div>
        <div className="form-group">
          <label>Password</label>
          <input type="password" placeholder="Enter password" value={password}
            onChange={e => setPassword(e.target.value)}
            onKeyDown={e => e.key === "Enter" && handleLogin()} />
        </div>
        {error && <div className="error-message">{error}</div>}
        <div className="button-group">
          <button onClick={handleLogin} disabled={loading}>
            {loading ? "Logging in..." : "Login"}
          </button>
          <button onClick={() => navigate("/register")}>Create Account</button>
        </div>
      </div>
    </div>
  )
}
EOF

# ─── REGISTER ─────────────────────────────────────────────────────────────────
cat > "$FRONTEND/components/Register.jsx" << 'EOF'
import { useState } from "react"
import { useNavigate } from "react-router-dom"
import { useAuth } from "../context/AuthContext"
import axios from "axios"

export default function Register() {
  const [username, setUsername] = useState("")
  const [password, setPassword] = useState("")
  const [error, setError] = useState("")
  const [loading, setLoading] = useState(false)
  const { login } = useAuth()
  const navigate = useNavigate()

  async function handleRegister() {
    if (!username || !password) {
      setError("Please fill in all fields")
      return
    }
    setLoading(true)
    setError("")
    try {
      const res = await axios.post("/bank/api/auth/register", { username, password })
      if (res.data.success) {
        login(res.data.data)
        navigate("/")
      } else {
        setError(res.data.message)
      }
    } catch (err) {
      setError(err.response?.data?.message || "Registration failed")
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="wrapper">
      <div className="container">
        <h1>Open Bank Account</h1>
        <h3>Register to get your account number</h3>
        <div className="form-group">
          <label>Username</label>
          <input type="text" placeholder="Choose a username" value={username}
            onChange={e => setUsername(e.target.value)} />
        </div>
        <div className="form-group">
          <label>Password</label>
          <input type="password" placeholder="Choose a password" value={password}
            onChange={e => setPassword(e.target.value)}
            onKeyDown={e => e.key === "Enter" && handleRegister()} />
        </div>
        {error && <div className="error-message">{error}</div>}
        <div className="button-group">
          <button onClick={handleRegister} disabled={loading}>
            {loading ? "Creating Account..." : "Register"}
          </button>
          <button onClick={() => navigate("/login")}>Already have account?</button>
        </div>
      </div>
    </div>
  )
}
EOF

# ─── WELCOME (with account info) ──────────────────────────────────────────────
cat > "$FRONTEND/components/Welcome.jsx" << 'EOF'
import { useNavigate } from "react-router-dom"
import { useAuth } from "../context/AuthContext"

export default function Welcome() {
  const navigate = useNavigate()
  const { user, logout } = useAuth()

  function handleLogout() {
    logout()
    navigate("/login")
  }

  return (
    <div className="wrapper">
      <div className="container">
        <h1>Welcome, {user?.username}!</h1>
        <div className="account-details">
          <h2>Your Account Details</h2>
          <p><strong>Account Number:</strong> {user?.accountNumber}</p>
          <p><strong>Balance:</strong> ₹{user?.balance?.toLocaleString()}</p>
        </div>
        <h3>What would you like to do?</h3>
        <ol>
          <li><button onClick={() => navigate('/add')}>Add a Deposit</button></li>
          <li><button onClick={() => navigate('/withdraw')}>Withdraw from Deposit</button></li>
          <li><button onClick={() => navigate('/account')}>Get Account Details</button></li>
          <li><button onClick={() => navigate('/loan')}>Take a Loan</button></li>
          <li><button onClick={() => navigate('/repay')}>Repay Credit/Loan</button></li>
        </ol>
        <div className="button-group">
          <button onClick={handleLogout}>Logout</button>
        </div>
      </div>
    </div>
  )
}
EOF

echo "✅ All frontend files updated"

# ─── REBUILD ──────────────────────────────────────────────────────────────────
BANK="/home/saisakthi/Coding-Project/Projects/Finished Projects/Docker/Terraform/projects/Bank Manager"

docker volume rm gateway_bank-dist 2>/dev/null || true
docker rm -f bank-frontend-build 2>/dev/null || true
docker rmi bank-frontend-build:latest 2>/dev/null || true

docker build --no-cache -t bank-frontend-build:latest \
  -f "$BANK/frontend/Dockerfile.prod" \
  "$BANK/frontend"

docker run -d --name bank-frontend-build \
  -v gateway_bank-dist:/dist \
  bank-frontend-build:latest

sleep 5
docker restart gateway

echo "✅ Done! Visit http://localhost/bank/"