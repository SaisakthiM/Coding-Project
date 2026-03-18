#!/bin/bash
set -e

BANK="/home/saisakthi/Coding-Project/Projects/Finished Projects/Docker/Terraform/projects/Bank Manager"
JAVA="$BANK/backend/bank_management/src/main/java/com/bankmanagement/bank_management"
FRONTEND="$BANK/frontend/src"

# ─── BACKEND ──────────────────────────────────────────────────────────────────

# 1. User entity
mkdir -p "$JAVA/database"
cat > "$JAVA/database/User.java" << 'EOF'
package com.bankmanagement.bank_management.database;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "users")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(unique = true, nullable = false)
    private String username;

    @Column(nullable = false)
    private String password;

    @OneToOne
    @JoinColumn(name = "account_id")
    private Bank account;
}
EOF

# 2. User repository
mkdir -p "$JAVA/repository"
cat > "$JAVA/repository/UserRepository.java" << 'EOF'
package com.bankmanagement.bank_management.repository;

import com.bankmanagement.bank_management.database.User;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface UserRepository extends JpaRepository<User, Long> {
    Optional<User> findByUsername(String username);
    boolean existsByUsername(String username);
}
EOF

# 3. Auth DTOs
mkdir -p "$JAVA/dto"
cat > "$JAVA/dto/AuthRequest.java" << 'EOF'
package com.bankmanagement.bank_management.dto;

import lombok.Data;

@Data
public class AuthRequest {
    private String username;
    private String password;
}
EOF

cat > "$JAVA/dto/AuthResponse.java" << 'EOF'
package com.bankmanagement.bank_management.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class AuthResponse {
    private String token;
    private String username;
    private String accountNumber;
    private Long accountId;
    private Long balance;
}
EOF

# 4. JWT utility
mkdir -p "$JAVA/security"
cat > "$JAVA/security/JwtUtil.java" << 'EOF'
package com.bankmanagement.bank_management.security;

import io.jsonwebtoken.*;
import io.jsonwebtoken.security.Keys;
import org.springframework.stereotype.Component;
import java.security.Key;
import java.util.Date;

@Component
public class JwtUtil {
    private static final String SECRET = "bankmanager-secret-key-2024-very-long-secret";
    private static final long EXPIRATION = 86400000; // 24 hours

    private Key getKey() {
        return Keys.hmacShaKeyFor(SECRET.getBytes());
    }

    public String generateToken(String username) {
        return Jwts.builder()
                .setSubject(username)
                .setIssuedAt(new Date())
                .setExpiration(new Date(System.currentTimeMillis() + EXPIRATION))
                .signWith(getKey(), SignatureAlgorithm.HS256)
                .compact();
    }

    public String extractUsername(String token) {
        return Jwts.parserBuilder()
                .setSigningKey(getKey())
                .build()
                .parseClaimsJws(token)
                .getBody()
                .getSubject();
    }

    public boolean validateToken(String token) {
        try {
            Jwts.parserBuilder().setSigningKey(getKey()).build().parseClaimsJws(token);
            return true;
        } catch (Exception e) {
            return false;
        }
    }
}
EOF

# 5. Auth service
mkdir -p "$JAVA/service"
cat > "$JAVA/service/AuthService.java" << 'EOF'
package com.bankmanagement.bank_management.service;

import com.bankmanagement.bank_management.database.Bank;
import com.bankmanagement.bank_management.database.User;
import com.bankmanagement.bank_management.dto.AuthRequest;
import com.bankmanagement.bank_management.dto.AuthResponse;
import com.bankmanagement.bank_management.repository.BankRepository;
import com.bankmanagement.bank_management.repository.UserRepository;
import com.bankmanagement.bank_management.security.JwtUtil;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.Random;

@Service
@RequiredArgsConstructor
public class AuthService {

    private final UserRepository userRepository;
    private final BankRepository bankRepository;
    private final JwtUtil jwtUtil;
    private final PasswordEncoder passwordEncoder;

    public AuthResponse register(AuthRequest request) {
        if (userRepository.existsByUsername(request.getUsername())) {
            throw new IllegalArgumentException("Username already exists");
        }

        // Generate unique account number
        String accountNumber = generateAccountNumber();

        // Create bank account
        Bank account = new Bank();
        account.setCustomerName(request.getUsername());
        account.setAccountNumber(accountNumber);
        account.setBalance(0L);
        account.setCreditScore(700);
        Bank savedAccount = bankRepository.save(account);

        // Create user
        User user = new User();
        user.setUsername(request.getUsername());
        user.setPassword(passwordEncoder.encode(request.getPassword()));
        user.setAccount(savedAccount);
        userRepository.save(user);

        String token = jwtUtil.generateToken(request.getUsername());
        return new AuthResponse(token, request.getUsername(), accountNumber, savedAccount.getId(), 0L);
    }

    public AuthResponse login(AuthRequest request) {
        User user = userRepository.findByUsername(request.getUsername())
                .orElseThrow(() -> new IllegalArgumentException("Invalid username or password"));

        if (!passwordEncoder.matches(request.getPassword(), user.getPassword())) {
            throw new IllegalArgumentException("Invalid username or password");
        }

        Bank account = user.getAccount();
        String token = jwtUtil.generateToken(request.getUsername());
        return new AuthResponse(token, user.getUsername(),
                account.getAccountNumber(), account.getId(), account.getBalance());
    }

    private String generateAccountNumber() {
        Random random = new Random();
        String accountNumber;
        do {
            accountNumber = "ACC" + String.format("%09d", random.nextInt(1000000000));
        } while (bankRepository.existsByAccountNumber(accountNumber));
        return accountNumber;
    }
}
EOF

# 6. Auth controller
cat > "$JAVA/controller/AuthController.java" << 'EOF'
package com.bankmanagement.bank_management.controller;

import com.bankmanagement.bank_management.dto.AuthRequest;
import com.bankmanagement.bank_management.dto.AuthResponse;
import com.bankmanagement.bank_management.dto.ApiResponse;
import com.bankmanagement.bank_management.service.AuthService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {

    private final AuthService authService;

    @PostMapping("/register")
    public ResponseEntity<ApiResponse> register(@RequestBody AuthRequest request) {
        try {
            AuthResponse response = authService.register(request);
            return ResponseEntity.ok(new ApiResponse(true, "Registration successful", response));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(new ApiResponse(false, e.getMessage()));
        }
    }

    @PostMapping("/login")
    public ResponseEntity<ApiResponse> login(@RequestBody AuthRequest request) {
        try {
            AuthResponse response = authService.login(request);
            return ResponseEntity.ok(new ApiResponse(true, "Login successful", response));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(new ApiResponse(false, e.getMessage()));
        }
    }
}
EOF

# 7. Security config
cat > "$JAVA/config/SecurityConfig.java" << 'EOF'
package com.bankmanagement.bank_management.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .csrf(csrf -> csrf.disable())
            .authorizeHttpRequests(auth -> auth
                .anyRequest().permitAll()
            );
        return http.build();
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}
EOF

# 8. Add existsByAccountNumber to BankRepository
cat > "$JAVA/repository/BankRepository.java" << 'EOF'
package com.bankmanagement.bank_management.repository;

import com.bankmanagement.bank_management.database.Bank;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface BankRepository extends JpaRepository<Bank, Long> {
    Optional<Bank> findByAccountNumber(String accountNumber);
    boolean existsByAccountNumber(String accountNumber);
}
EOF

echo "✅ Backend files created"

# ─── CHECK POMS FOR DEPENDENCIES ──────────────────────────────────────────────
echo ""
echo "⚠️  Add these dependencies to pom.xml if not present:"
echo ""
echo "<dependency>"
echo "  <groupId>io.jsonwebtoken</groupId>"
echo "  <artifactId>jjwt-api</artifactId>"
echo "  <version>0.11.5</version>"
echo "</dependency>"
echo "<dependency>"
echo "  <groupId>io.jsonwebtoken</groupId>"
echo "  <artifactId>jjwt-impl</artifactId>"
echo "  <version>0.11.5</version>"
echo "</dependency>"
echo "<dependency>"
echo "  <groupId>io.jsonwebtoken</groupId>"
echo "  <artifactId>jjwt-jackson</artifactId>"
echo "  <version>0.11.5</version>"
echo "</dependency>"
echo "<dependency>"
echo "  <groupId>org.springframework.boot</groupId>"
echo "  <artifactId>spring-boot-starter-security</artifactId>"
echo "</dependency>"

# ─── FRONTEND ──────────────────────────────────────────────────────────────────

# Auth context
cat > "$FRONTEND/context/AuthContext.jsx" << 'EOF'
import { createContext, useContext, useState } from "react"

const AuthContext = createContext(null)

export function AuthProvider({ children }) {
  const [user, setUser] = useState(() => {
    const stored = localStorage.getItem("bankUser")
    return stored ? JSON.parse(stored) : null
  })

  function login(userData) {
    localStorage.setItem("bankUser", JSON.stringify(userData))
    setUser(userData)
  }

  function logout() {
    localStorage.removeItem("bankUser")
    setUser(null)
  }

  return (
    <AuthContext.Provider value={{ user, login, logout }}>
      {children}
    </AuthContext.Provider>
  )
}

export function useAuth() {
  return useContext(AuthContext)
}
EOF

# Login page
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
        <h1>Bank Manager Login</h1>
        <input type="text" placeholder="Username" value={username}
          onChange={e => setUsername(e.target.value)} />
        <input type="password" placeholder="Password" value={password}
          onChange={e => setPassword(e.target.value)} />
        <button onClick={handleLogin} disabled={loading}>
          {loading ? "Logging in..." : "Login"}
        </button>
        <button onClick={() => navigate("/register")}>Register</button>
        {error && <p style={{color:"red"}}>{error}</p>}
      </div>
    </div>
  )
}
EOF

# Register page
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
        <h1>Create Bank Account</h1>
        <p>Register to get your account number automatically!</p>
        <input type="text" placeholder="Username" value={username}
          onChange={e => setUsername(e.target.value)} />
        <input type="password" placeholder="Password" value={password}
          onChange={e => setPassword(e.target.value)} />
        <button onClick={handleRegister} disabled={loading}>
          {loading ? "Creating account..." : "Register"}
        </button>
        <button onClick={() => navigate("/login")}>Already have account? Login</button>
        {error && <p style={{color:"red"}}>{error}</p>}
      </div>
    </div>
  )
}
EOF

# Protected route
cat > "$FRONTEND/components/ProtectedRoute.jsx" << 'EOF'
import { Navigate } from "react-router-dom"
import { useAuth } from "../context/AuthContext"

export default function ProtectedRoute({ children }) {
  const { user } = useAuth()
  if (!user) return <Navigate to="/login" replace />
  return children
}
EOF

# Update App.jsx
cat > "$FRONTEND/App.jsx" << 'EOF'
import { BrowserRouter, Routes, Route } from "react-router-dom"
import { AuthProvider } from "./context/AuthContext"
import ProtectedRoute from "./components/ProtectedRoute"
import Welcome from "./components/Welcome.jsx"
import AddDeposit from "./components/AddDeposit.jsx"
import Withdraw from "./components/Withdraw.jsx"
import GetAccount from "./components/GetAccount.jsx"
import Loan from "./components/Loan.jsx"
import Repay from "./components/Repay.jsx"
import Login from "./components/Login.jsx"
import Register from "./components/Register.jsx"
import "./style.css"

function App() {
  return (
    <AuthProvider>
      <BrowserRouter basename="/bank/">
        <Routes>
          <Route path="/login" element={<Login />} />
          <Route path="/register" element={<Register />} />
          <Route path="/" element={<ProtectedRoute><Welcome /></ProtectedRoute>} />
          <Route path="/add" element={<ProtectedRoute><AddDeposit /></ProtectedRoute>} />
          <Route path="/withdraw" element={<ProtectedRoute><Withdraw /></ProtectedRoute>} />
          <Route path="/account" element={<ProtectedRoute><GetAccount /></ProtectedRoute>} />
          <Route path="/loan" element={<ProtectedRoute><Loan /></ProtectedRoute>} />
          <Route path="/repay" element={<ProtectedRoute><Repay /></ProtectedRoute>} />
        </Routes>
      </BrowserRouter>
    </AuthProvider>
  )
}

export default App
EOF

echo "✅ Frontend files created"
echo ""
echo "Next steps:"
echo "1. Add JWT + Spring Security dependencies to pom.xml"
echo "2. Rebuild backend: docker build -t bankmanager-backend:latest ..."
echo "3. Rebuild frontend: docker build -t bank-frontend-build:latest ..."