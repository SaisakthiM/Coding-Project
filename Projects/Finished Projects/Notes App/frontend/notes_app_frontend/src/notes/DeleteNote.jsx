import { useEffect, useState } from "react";
import { getAllNotes, deleteNote } from "./NoteHandler";
import { Link } from "react-router-dom";

function DeleteNote() {
  const [notes, setNotes] = useState([]);

  const fetchNotes = async () => {
    const data = await getAllNotes();
    setNotes(data);
  };

  useEffect(() => {
    fetchNotes();
  }, []);

  const handleDelete = async (id) => {
    await deleteNote(id);
    fetchNotes();
  };

  return (
    <div className="wrapper">
      <div className="container">
        <h1 className="main">Your Notes</h1>

        <div className="notes-list">
          {notes.length === 0 ? (
            <p>No notes available.</p>
          ) : (
            notes.map((note) => (
              <div key={note.id} className="note-item">
                <div style={{ flexGrow: 1 }}>
                  <h3 style={{ margin: "0 0 8px" }}>{note.title}</h3>
                  <p>{note.content}</p>
                  <p>
                    <strong>Deadline:</strong> {note.deadline}
                  </p>
                  <p>
                    <strong>Importance:</strong> {note.importance}
                  </p>
                </div>

                <div className="actions">
                  <Link to={`/edit/${note.id}`}>
                    <button>Edit</button>
                  </Link>

                  <button onClick={() => handleDelete(note.id)}>Delete</button>
                </div>
              </div>
            ))
          )}
        </div>
      </div>
    </div>
  );
}

export default DeleteNote;
