// LoginPage.jsx
import React, { useContext, useState } from "react";
import AuthService from "./AuthService.js";
import "../styles.css";
import { UserProvider } from "./UserProvider.jsx";

export default function LoginPage({isRegistered}) {
    const [username, setUsername] = useState("");
    const [password, setPassword] = useState("");
    const [loading, setLoading] = useState(false);
    const [message, setMessage] = useState(null);
    const {login, setLogin} = useContext(UserProvider);

    async function handleLogin() {
        setLoading(true);
        setMessage(null);
        try {
            const api = new AuthService(username, password);
            const tokens = await api.login();
            localStorage.setItem("access", tokens.access);
            localStorage.setItem("refresh", tokens.refresh);
            console.log(api)
            setMessage("Login successful.");
            setLogin(true)
        } catch (err) {
            console.error(err);
            const errMsg =
                err.response?.data || err.message || "Login failed.";
            setMessage(JSON.stringify(errMsg));
        } finally {
            setLoading(false);
        }
    }

    return (
        <div className="wrapper">
            <div className="container">
                <h1>Login</h1>
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

                <div>
                    <button type="button" onClick={handleLogin} disabled={loading}>
                        {loading ? "Logging in..." : "Login"}
                    </button>
                </div>

                {message && <p>{message}</p>}
            </div>
        </div>
    );
}
