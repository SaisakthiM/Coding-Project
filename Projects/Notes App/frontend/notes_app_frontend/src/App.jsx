import React, { useContext, useState } from "react";
import RegisterPage from "./components/Register";
import LoginPage from "./components/Login";
import { UserContext } from "./components/UserContext";
import RegistrationComplete from "./components/RegistrationComplete";
import "./styles.css";

export default function App() {
  const { registered } = useContext(UserContext);
  const [showLogin, setShowLogin] = useState(false);

  // Case 1: user already registered -> show login
  // Case 2: user not registered -> show register page

  return (
    <div>
      {registered ? <RegistrationComplete></RegistrationComplete> : <RegisterPage></RegisterPage>}
    </div>
  );
}
