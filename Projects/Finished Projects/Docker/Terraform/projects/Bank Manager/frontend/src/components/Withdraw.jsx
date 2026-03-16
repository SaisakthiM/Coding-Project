import { useState } from "react";
import { useNavigate } from "react-router-dom";
import bankService from "./bankService";

export default function Withdraw() {
    const navigate = useNavigate();
    const [accountId, setAccountId] = useState("");
    const [amount, setAmount] = useState("");
    const [loading, setLoading] = useState(false);
    const [message, setMessage] = useState("");
    const [error, setError] = useState("");

    const handleWithdraw = async (e) => {
        e.preventDefault();
        setLoading(true);
        setMessage("");
        setError("");

        try {
            const response = await bankService.withdraw(parseInt(accountId), parseInt(amount));
            if (response.success) {
                setMessage(`Successfully withdrew $${amount}! New balance: $${response.data.balance}`);
                setAccountId("");
                setAmount("");
            }
        } catch (err) {
            setError(err.message || "Failed to withdraw money");
        } finally {
            setLoading(false);
        }
    };

    return (
        <div className="wrapper">
            <div className="container">
                <h1>Withdraw Money</h1>
                
                {message && <div className="success-message">{message}</div>}
                {error && <div className="error-message">{error}</div>}

                <form onSubmit={handleWithdraw}>
                    <div className="form-group">
                        <label>Account ID:</label>
                        <input
                            type="number"
                            value={accountId}
                            onChange={(e) => setAccountId(e.target.value)}
                            required
                            placeholder="Enter account ID"
                        />
                    </div>

                    <div className="form-group">
                        <label>Amount:</label>
                        <input
                            type="number"
                            value={amount}
                            onChange={(e) => setAmount(e.target.value)}
                            required
                            min="1"
                            placeholder="Enter amount to withdraw"
                        />
                    </div>

                    <div className="button-group">
                        <button type="submit" disabled={loading}>
                            {loading ? "Processing..." : "Withdraw"}
                        </button>
                        <button type="button" onClick={() => navigate("/")}>
                            Back to Home
                        </button>
                    </div>
                </form>
            </div>
        </div>
    );
}