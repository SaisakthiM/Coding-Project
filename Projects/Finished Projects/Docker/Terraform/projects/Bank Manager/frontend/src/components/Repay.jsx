import { useNavigate } from "react-router-dom";

export default function Repay() {
    const navigate = useNavigate();

    return (
        <div className="wrapper">
            <div className="container">
                <h1>Repay Credit/Loan</h1>
                <p>Repayment feature coming soon! This will be implemented after you add loan endpoints to the backend.</p>
                <button onClick={() => navigate("/")}>Back to Home</button>
            </div>
        </div>
    );
}