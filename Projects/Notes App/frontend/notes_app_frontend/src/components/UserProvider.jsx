// UserProvider.js
import { useState, useEffect } from "react";
import { UserContext } from "./UserContext";
import axios from "axios";

export const UserProvider = ({ children }) => {
  const [registered, setRegistered] = useState(false);
  const [login, setLogin] = useState(false);
  const [beforeLogin, setBeforeLogin] = useState(false);
  const [loading, setLoading] = useState(true);

  // ✅ Auto-refresh token when expired
  async function refreshToken() {
    const refresh = localStorage.getItem("refresh");
    if (!refresh) return false;

    try {
      const response = await axios.post("http://localhost:8000/api/token/refresh/", {
        refresh: refresh,
      });

      localStorage.setItem("access", response.data.access);
      console.log("🔄 Access token refreshed.");
      return true;
    } catch (err) {
      console.error("Token refresh failed:", err.response?.data || err.message);
      localStorage.removeItem("access");
      localStorage.removeItem("refresh");
      return false;
    }
  }

  // ✅ Check token validity and restore session
  async function validateSession() {
    const access = localStorage.getItem("access");
    const refresh = localStorage.getItem("refresh");

    if (!access && !refresh) {
      setBeforeLogin(true);
      setLoading(false);
      return;
    }

    try {
      // Verify token by calling a protected API endpoint
      await axios.get("http://localhost:8000/api/notes/", {
        headers: { Authorization: `Bearer ${access}` },
      });

      // Token is valid
      setLogin(true);
      setRegistered(true);
      setBeforeLogin(false);
      console.log("✅ Session restored with valid token.");
    } catch (err) {
      // If expired, try refresh
      const refreshed = await refreshToken();
      if (refreshed) {
        setLogin(true);
        setRegistered(true);
        setBeforeLogin(false);
      } else {
        setBeforeLogin(true);
        setLogin(false);
        setRegistered(false);
      }
    }

    setLoading(false);
  }

  useEffect(() => {
    validateSession();
  }, []);

  // Sync UI state to localStorage
  useEffect(() => {
    localStorage.setItem("isRegistered", registered);
    localStorage.setItem("isLoggedIn", login);
  }, [registered, login]);

  if (loading) return <div>Loading session...</div>;

  return (
    <UserContext.Provider
      value={{
        registered,
        setRegistered,
        login,
        setLogin,
        beforeLogin,
        setBeforeLogin,
      }}
    >
      {children}
    </UserContext.Provider>
  );
};
