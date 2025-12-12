import { useEffect, useState } from "react";
import { useParams, useNavigate } from "react-router-dom";
import { getAllNotes, updateNote } from "./NoteHandler.js";

function ModifyNote() {
  const { id } = useParams();
  const navigate = useNavigate();
  const [note, setNote] = useState(null);

  const fetchNote = async () => {
    const data = await getAllNotes();
    const selected = data.find((n) => n.id.toString() === id);
    setNote(selected);
  };

  useEffect(() => {
    fetchNote();
  }, []);

  const handleUpdate = async () => {
    await updateNote(id, note);
    navigate("/");
  };

  if (!note) return <p>Loading...</p>;

  return (
    <div className="wrapper">
      <div className="container">
        <h1>Edit Note</h1>

        <div className="loginLabel">
          <input
            className="inputLogin"
            type="text"
            value={note.title}
            onChange={(e) => setNote({ ...note, title: e.target.value })}
            placeholder="Title"
          />
        </div>

        <div className="loginLabel">
          <textarea
            className="inputLogin"
            style={{ height: "100px", resize: "vertical" }}
            value={note.content}
            onChange={(e) => setNote({ ...note, content: e.target.value })}
            placeholder="Content"
          />
        </div>

        <div className="loginLabel">
          <input
            className="inputLogin"
            type="date"
            value={note.deadline}
            onChange={(e) => setNote({ ...note, deadline: e.target.value })}
          />
        </div>

        <div className="loginLabel">
          <input
            className="inputLogin"
            type="text"
            value={note.importance}
            onChange={(e) => setNote({ ...note, importance: e.target.value })}
            placeholder="Importance"
          />
        </div>

        <div className="loginButton">
          <button onClick={handleUpdate}>Update</button>
        </div>
      </div>
    </div>
  );
}

export default ModifyNote;
