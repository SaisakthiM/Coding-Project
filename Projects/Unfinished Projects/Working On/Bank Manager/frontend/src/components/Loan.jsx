import { useNavigate } from "react-router-dom";

export default function Loan() {
    const navigate = useNavigate();

    return (
        <div className="wrapper">
            <div className="container">
                <h1>Take a Loan</h1>
                <p>Loan feature coming soon! This will be implemented after you add loan endpoints to the backend.</p>
                <button onClick={() => navigate("/")}>Back to Home</button>
            </div>
        </div>
    );
}