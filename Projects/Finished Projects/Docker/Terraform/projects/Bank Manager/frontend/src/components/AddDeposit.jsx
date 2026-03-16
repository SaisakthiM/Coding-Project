import { useState } from "react";
import { useNavigate } from "react-router-dom";
import bankService from "./bankService";

export default function AddDeposit() {
    const navigate = useNavigate();
    const [accountId, setAccountId] = useState(0);
    const [amount, setAmount] = useState(0);
    const [loading, setLoading] = useState(false);
    const [message, setMessage] = useState("");
    const [error, setError] = useState("");

    const handleDeposit = async (e) => {
        e.preventDefault();
        setLoading(true);
        setMessage("");
        setError("");

        try {
            const response = await bankService.deposit(parseInt(accountId), parseInt(amount));
            if (response.success) {
                setMessage(`Successfully deposited $${amount}! New balance: $${response.data.balance}`);
                setAccountId(0);
                setAmount(0);
            }
        } catch (err) {
            setError(err.message || "Failed to deposit money");
        } finally {
            setLoading(false);
        }
    };

    return (
        <div className="wrapper">
            <div className="container">
                <h1>Add Deposit</h1>
                
                {message && <div className="success-message">{message}</div>}
                {error && <div className="error-message">{error}</div>}

                <form onSubmit={handleDeposit}>
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
                            placeholder="Enter amount to deposit"
                        />
                    </div>

                    <div className="button-group">
                        <button type="submit" disabled={loading}>
                            {loading ? "Processing..." : "Deposit"}
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