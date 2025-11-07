// RegisterPage.jsx
import React, { useState, useContext } from "react";
import "../styles.css";
import { UserContext } from "./UserContext.js";
import { registerUser } from "../api/authServices.js";

export default function RegisterPage() {
  const [username, setUsername] = useState("");
  const [password, setPassword] = useState("");
  const [loading, setLoading] = useState(false);
  const [message, setMessage] = useState(null);
  const { setRegistered } = useContext(UserContext);

  // ✅ Add handler here
  async function handleRegister() {
    setLoading(true);
    setMessage(null);
    try {
      const result = await registerUser(username, password); // pass inputs here
      console.log("Register response:", result);
      setMessage("Registration successful!");
      setRegistered(true); // Move to next page
    } catch (err) {
      console.error(err);
      const errMsg = err.response?.data || err.message || "Registration failed.";
      setMessage(JSON.stringify(errMsg));
    } finally {
      setLoading(false);
    }
  }

  return (
    <div className="wrapper">
      <div className="container">
        <h1>Register</h1>
        <div>
          <label>
            Username : &nbsp;
            <input
              type="text"
              value={username}
              onChange={(e) => setUsername(e.target.value)}
              placeholder="Username"
            />
          </label>
        </div>
        <div>
          <label>
            Password : &nbsp;
            <input
              type="password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              placeholder="Password"
            />
          </label>
        </div>

        <div className="buttons">
          {/* ✅ Call the handler, not registerUser directly */}
          <button
            type="button"
            onClick={handleRegister}
            disabled={loading}
          >
            {loading ? "Registering..." : "Register"}
          </button>

          <button
            type="button"
            onClick={() => setRegistered(true)}
          >
            Go To Login
          </button>
        </div>

        {message && <p>{message}</p>}
      </div>
    </div>
  );
}
