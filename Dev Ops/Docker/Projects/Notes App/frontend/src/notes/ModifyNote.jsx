import { useState, useEffect } from "react";
import axios from "axios";
import { updateNote, refreshAccessToken } from "./NoteHandler";
import "../styles.css";

export default function UpdateNote() {
  const [notes, setNotes] = useState([]);
  const [loading, setLoading] = useState(true);
  const [editingNote, setEditingNote] = useState(null);
  const API_BASE_URL = "http://192.168.31.227:8000/api"; // LAN IP

  useEffect(() => {
    async function fetchNotes() {
      try {
        const token = localStorage.getItem("access");
        const res = await axios.get(`${API_BASE_URL}/notes/`, {
          headers: { Authorization: `Bearer ${token}` },
        });
        console.log(res);
        setNotes(res.data);
      } catch (err) {
        console.error("Failed to fetch notes:", err);
      } finally {
        setLoading(false);
      }
    }

    fetchNotes();
  }, []);

  const handleEdit = (note) => {
    setEditingNote(note); // store the selected note
  };

  if (loading) return <p>Loading...</p>;

  return (
    <div className="wrapper">
      <div className="container">
        <h1>All Notes</h1>
        {editingNote ? (
          <EditNoteForm
            note={editingNote}
            onUpdate={(updated) => {
              setNotes(notes.map(n => n.id === updated.id ? updated : n));
              setEditingNote(null);
            }}
          />
        ) : (
          <div className="notes-list">
            {notes.map((note) => (
              <div key={note.id} className="note-item">
                <p>{note.title} - {note.content}</p>
                <div className="actions">
                  <button onClick={() => handleEdit(note)}>Edit</button>
                </div>
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  );
}

function EditNoteForm({ note, onUpdate }) {
  const [task, setTask] = useState({ ...note });

  const handleChange = (e) => {
    const { name, value } = e.target;
    setTask((prev) => ({ ...prev, [name]: value }));
  };

  const handleSubmit = async () => {
    await refreshAccessToken();
    const updated = await updateNote(task.id, task);
    onUpdate(updated);
  };

  return (
    <div>
      <h2>Edit Note</h2>
      <input name="title" value={task.title} onChange={handleChange} />
      <input name="content" value={task.content} onChange={handleChange} />
      <input
        name="deadline"
        type="date"
        value={task.deadline?.slice(0, 10)}
        onChange={handleChange}
      />
      <select name="importance" value={task.importance} onChange={handleChange}>
        <option value="low">Low</option>
        <option value="medium">Medium</option>
        <option value="high">High</option>
      </select>
      <button onClick={handleSubmit}>Save</button>
    </div>
  );
}
