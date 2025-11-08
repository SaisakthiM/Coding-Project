import React, { useContext, useEffect } from "react";
import { UserContext } from "./components/UserContext";
import RegisterPage from "./components/Register";
import LoginPage from "./components/Login";
import RegistrationComplete from "./components/RegistrationComplete";
import "./styles.css";
import Notes from "./notes/Notes";

export default function App() {
  const { registered, beforeLogin, login, setLogin } = useContext(UserContext);

  useEffect(() => {
    const token = localStorage.getItem('access');
    if (token) {
      setLogin(true);
    }
  }, [setLogin]);

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
      <Notes></Notes>
    );
  }

  return null;
}
