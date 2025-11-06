// RegisterPage.jsx
import React, { useState } from "react";
import AuthService from "./AuthService.js";
import "../styles.css";
import { useContext } from "react";
import { UserContext } from "./UserContext.js";

export default function RegisterPage({isRegistered}) {
    const [username, setUsername] = useState("");
    const [password, setPassword] = useState("");
    const [loading, setLoading] = useState(false);
    const [message, setMessage] = useState(null);   
    const { registered, setRegistered } = useContext(UserContext);

    async function handleRegister() {
        setLoading(true);
        setMessage(null);
        try {
        const api = new AuthService(username, password);
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
                        placeholder=" Username"
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
                    {/* Use type="button" so this doesn't submit a form automatically */}
                    <button type="button" onClick={() => {handleRegister; setRegistered(true)}} disabled={loading}>
                        {loading ? "Registering..." : "Register"}
                    </button>
                    <button type="button" onClick={() => {setRegistered(true)}}>Go To Login</button>
                </div>

                {message && <p>{message}</p>}
                
            </div>
        </div>
    );
}
