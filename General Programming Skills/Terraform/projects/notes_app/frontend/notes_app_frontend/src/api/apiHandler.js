// src/api/apiHandler.js
import axios from "axios";

const API_BASE = "http://127.0.0.1:8000/api"; // Change to your backend URL

// Create Axios instance
const api = axios.create({
  baseURL: API_BASE,
});

// Automatically attach the access token to every request
api.interceptors.request.use((config) => {
  const token = localStorage.getItem("access");
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

// Auto-refresh token if expired
api.interceptors.response.use(
  (response) => response,
  async (error) => {
    const originalRequest = error.config;

    // If access token expired and we haven't retried yet
    if (
      error.response &&
      error.response.status === 401 &&
      !originalRequest._retry
    ) {
      originalRequest._retry = true;
      const refresh = localStorage.getItem("refresh");
      if (refresh) {
        try {
          const res = await axios.post(`${API_BASE}/token/refresh/`, {
            refresh,
          });
          const newAccess = res.data.access;
          localStorage.setItem("access", newAccess);
          api.defaults.headers.Authorization = `Bearer ${newAccess}`;
          originalRequest.headers.Authorization = `Bearer ${newAccess}`;
          return api(originalRequest); // Retry the original request
        } catch (err) {
          console.error("Token refresh failed:", err);
          localStorage.removeItem("access");
          localStorage.removeItem("refresh");
          window.location.href = "/login"; // optional redirect
        }
      }
    }

    return Promise.reject(error);
  }
);

export default api;
