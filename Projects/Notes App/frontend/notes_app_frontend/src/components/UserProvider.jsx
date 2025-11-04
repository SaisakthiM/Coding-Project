// UserProvider.js
import { useState } from "react";
import { UserContext } from "./UserContext";

export const UserProvider = ({ children }) => {
  const [registered, setRegistered] = useState(false);
  return (
    <UserContext.Provider value={{ registered, setRegistered }}>
      {children}
    </UserContext.Provider>
  );
};
