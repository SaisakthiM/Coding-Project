import axios from "axios";

const API_BASE_URL = "http://localhost:8000/api";
const getAccessKey = () => localStorage.getItem("access");
const getRefreshKey = () => localStorage.getItem("refresh");

// 🟩 CREATE NOTE
export async function addNote(title, content, deadline, importance) {
  const url = `${API_BASE_URL}/notes/`;

  const body = {
    title,
    content,
    deadline,
    importance,
  };

  const config = {
    headers: {
      "Content-Type": "application/json",
      Authorization: `Bearer ${getAccessKey()}`,
    },
  };

  try {
    const response = await axios.post(url, body, config);
    console.log("✅ Note created:", response.data);
    return response.data;
  } catch (err) {
    console.error("❌ Error creating note:", err.response?.data || err.message);
  }
}

export async function refreshAccessToken() {
  const url = `${API_BASE_URL}/token/refresh/`;

  const body = {
    refresh: getRefreshKey(),
  };

  try {
    const response = await axios.post(url, body, {
      headers: { "Content-Type": "application/json" },
    });

    localStorage.setItem("access", response.data.access);
    console.log("🔁 Access token refreshed successfully");
    return response.data.access;

  } catch (err) {
    console.error("❌ Error refreshing token:", err.response?.data || err.message);

    // if token invalid or expired → logout
    if (err.response?.status === 401) {
      logoutUser();
    }
  }
}

// 🟦 UPDATE NOTE
export async function updateNote(id, data) {
  const url = `${API_BASE_URL}/notes/${id}/`;

  try {
    const response = await axios.patch(url, data, {
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${getAccessKey()}`,
      },
    });

    console.log("✏️ Note updated:", response.data);
    return response.data;

  } catch (err) {
    console.error("❌ Error updating note:", err.response?.data || err.message);
  }
}

// 🟥 DELETE NOTE
export async function deleteNote(id) {
  const url = `${API_BASE_URL}/notes/${id}/`;

  try {
    const response = await axios.delete(url, {
      headers: {
        Authorization: `Bearer ${getAccessKey()}`,
      },
    });

    console.log(`🗑️ Note deleted (ID: ${id})`);
    return response.data;

  } catch (err) {
    console.error("❌ Error deleting note:", err.response?.data || err.message);
  }
}

export function logoutUser() {
    localStorage.removeItem("access");
    localStorage.removeItem("refresh");

    console.log("🔓 User logged out. Tokens cleared.");
}
