import "../styles.css";
import { useNavigate } from "react-router-dom";
import {refreshAccessToken, logoutUser } from "../notes/NoteHandler.js";

export default function Notes() {
    const navigate = useNavigate();

    const handleLogout = () => {
        logoutUser();
        navigate("/login");
    };

    return (
        <div className="wrapper">
            <div className="container">
                <h1 className="main">Notes App</h1>
                <p>This is Notes App. Here, You can </p>

                <ol className="button_notes">
                    <li><button onClick={() => navigate('/addnote')}>Add a Note</button></li>
                    <li><button onClick={() => navigate('/updatenote')}>Modify a Note</button></li>
                    <li><button onClick={() => navigate('/deletenote')}>Delete a Note</button></li>
                    <li><button onClick={refreshAccessToken}>Refresh Token</button></li>
                    <li><button onClick={handleLogout}>Logout</button></li>
                </ol>
            </div>
        </div>
    );
}
