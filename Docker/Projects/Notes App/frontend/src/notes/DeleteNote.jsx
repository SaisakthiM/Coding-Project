import { useState, useEffect } from "react";
import axios from "axios";
import { deleteNote, refreshAccessToken } from "./NoteHandler";
import "../styles.css";

export default function DeleteNote({ noteId }) {
    const [note, setNote] = useState(null);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        async function fetchNote() {
            try {
                const token = localStorage.getItem("access");

                const res = await axios.get(
                    `http://localhost:8000/api/notes/${noteId}/`,
                    { headers: { Authorization: `Bearer ${token}` } }
                );

                setNote(res.data);
            } catch (error) {
                console.error("Failed to fetch note:", error);
            } finally {
                setLoading(false);
            }
        }

        if (noteId) fetchNote();
    }, [noteId]);

    const handleDelete = async () => {
        try {
            await refreshAccessToken();
            await deleteNote(noteId);
            alert("Note deleted successfully!");
        } catch (err) {
            console.error("Delete failed:", err);
            alert("Failed to delete note.");
        }
    };

    if (loading) return <h2>Loading...</h2>;
    if (!note) return <h2>Note not found.</h2>;

    return (
        <div className="wrapper">
            <div className="container">
                <h1>Delete Note</h1>

                <div className="note-preview">
                    <p><strong>Title:</strong> {note.title}</p>
                    <p><strong>Content:</strong> {note.content}</p>
                    <p><strong>Deadline:</strong> {note.deadline}</p>
                    <p><strong>Importance:</strong> {note.importance}</p>
                </div>

                <button
                    style={{ backgroundColor: "red", color: "white" }}
                    onClick={handleDelete}
                >
                    Delete Note
                </button>
            </div>
        </div>
    );
}
