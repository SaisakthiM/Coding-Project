import React, { useContext } from "react";
import { UserContext } from "./components/UserContext";
import RegisterPage from "./components/Register";
import LoginPage from "./components/Login";
import RegistrationComplete from "./components/RegistrationComplete";
import "./styles.css";

export default function App() {
  const { registered, beforeLogin, login } = useContext(UserContext);

  if (!registered) {
    return <RegisterPage />;
  }

  if (registered && !beforeLogin) {
    return <RegistrationComplete />;
  }

  if (beforeLogin && !login) {
    return <LoginPage />;
  }

  if (login) {
    return (
      <div className="wrapper">
        <h1>🎉 Welcome! You are logged in.</h1>
      </div>
    );
  }

  return null;
}
