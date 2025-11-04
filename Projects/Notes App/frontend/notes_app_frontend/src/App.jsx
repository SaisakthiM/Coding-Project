import React, { useContext, useState } from "react";
import RegisterPage from "./components/Register";
import LoginPage from "./components/Login";
import { UserContext } from "./components/UserContext";

export default function App() {
  const { registered } = useContext(UserContext);
  const [showLogin, setShowLogin] = useState(false);

  // Case 1: user already registered -> show login
  // Case 2: user not registered -> show register page

  return (
    <div>
      {registered && !showLogin ? (
        <div style={{ textAlign: "center", marginTop: "100px" }}>
          <h2>Registration successful 🎉</h2>
          <button onClick={() => setShowLogin(true)}>Go to Login</button>
        </div>
      ) : showLogin ? (
        <LoginPage />
      ) : (
        <RegisterPage />
      )}
    </div>
  );
}
