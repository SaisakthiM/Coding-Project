// RegisterPage.jsx
import React, { useState } from "react";
import RegisterAPI from "./retriever.js";

export default function RegisterPage() {
    const [username, setUsername] = useState("");
    const [password, setPassword] = useState("");
    const [loading, setLoading] = useState(false);
    const [message, setMessage] = useState(null);

    async function handleRegister() {
        setLoading(true);
        setMessage(null);
        try {
        const api = new RegisterAPI(username, password);
        const result = await api.register();
        setMessage("Registration successful.");
        console.log("register response:", result);
        // optional: auto-login
        // const tokens = await api.get_token();
        // localStorage.setItem("access", tokens.access);
        // localStorage.setItem("refresh", tokens.refresh);
        } catch (err) {
        console.error(err);
        // extract useful error message if available
        const errMsg =
            err.response?.data || err.message || "Registration failed.";
        setMessage(JSON.stringify(errMsg));
        } finally {
        setLoading(false);
        }
    }

    return (
        <div>
        <h2>Register</h2>
        <div>
            <label>
            Username
            <input
                type="text"
                value={username}
                onChange={(e) => setUsername(e.target.value)}
                placeholder="username"
            />
            </label>
        </div>
        <div>
            <label>
            Password
            <input
                type="password"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                placeholder="password"
            />
            </label>
        </div>

        {/* Use type="button" so this doesn't submit a form automatically */}
        <button type="button" onClick={handleRegister} disabled={loading}>
            {loading ? "Registering..." : "Register"}
        </button>

        {message && <p>{message}</p>}
        </div>
    );
}
