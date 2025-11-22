import { useState, useEffect } from "react";
import { deleteNote, refreshAccessToken } from "./NoteHandler";
import axios from "axios";
import "../styles.css";

export default function DeleteNote() {
  const [notes, setNotes] = useState([]);
  const [loading, setLoading] = useState(true);
  const API_BASE_URL = "http://192.168.31.227:8000/api"; // LAN IP

  useEffect(() => {
    async function fetchNotes() {
      try {
        await refreshAccessToken();
        const token = localStorage.getItem("access");
        const res = await axios.get(`${API_BASE_URL}/notes/`, {
          headers: { Authorization: `Bearer ${token}` },
        });
        setNotes(res.data);
      } catch (err) {
        console.error("Failed to fetch notes:", err.response || err);
      } finally {
        setLoading(false);
      }
    }

    fetchNotes();
  }, []);

  const handleDelete = async (id) => {
    const confirmDelete = window.confirm("Are you sure you want to delete this note?");
    if (!confirmDelete) return;

    const success = await deleteNote(id);
    if (success) {
      setNotes(notes.filter((n) => n.id !== id));
    }
  };

  if (loading) return <p>Loading...</p>;

  return (
    <div className="wrapper">
      <div className="container">
        <h1>All Notes</h1>
        <div className="notes-list">
          {notes.map((note) => (
            <div key={note.id} className="note-item">
              <p>
                <strong>{note.title}</strong> - {note.content}
              </p>
              <div className="actions">
                <button className="delete-btn" onClick={() => handleDelete(note.id)}>
                  Delete
                </button>
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}
