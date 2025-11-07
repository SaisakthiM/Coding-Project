// UserProvider.js
import { useState } from "react";
import { UserContext } from "./UserContext";

export const UserProvider = ({ children }) => {
  const [registered, setRegistered] = useState(false);
  const [login, setLogin] = useState(false)
  const [beforeLogin, setBeforeLogin] = useState(false);
  return (
    <UserContext.Provider value={{ registered, setRegistered, login, setLogin, beforeLogin, setBeforeLogin}}>
      {children}
    </UserContext.Provider>
  );
};
