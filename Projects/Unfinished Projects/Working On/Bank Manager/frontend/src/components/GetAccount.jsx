import { useState } from "react";
import { useNavigate } from "react-router-dom";
import bankService from "./bankService";

export default function GetAccount() {
    const navigate = useNavigate();
    const [accountId, setAccountId] = useState("");
    const [account, setAccount] = useState(null);
    const [loading, setLoading] = useState(false);
    const [error, setError] = useState("");

    const handleGetAccount = async (e) => {
        e.preventDefault();
        setLoading(true);
        setError("");
        setAccount(null);

        try {
            const response = await bankService.getAccountById(parseInt(accountId));
            if (response.success) {
                setAccount(response.data);
            }
        } catch (err) {
            setError(err.message || "Failed to fetch account");
        } finally {
            setLoading(false);
        }
    };

    return (
        <div className="wrapper">
            <div className="container">
                <h1>Get Account Details</h1>
                
                {error && <div className="error-message">{error}</div>}

                <form onSubmit={handleGetAccount}>
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

                    <div className="button-group">
                        <button type="submit" disabled={loading}>
                            {loading ? "Loading..." : "Get Account"}
                        </button>
                        <button type="button" onClick={() => navigate("/")}>
                            Back to Home
                        </button>
                    </div>
                </form>

                {account && (
                    <div className="account-details">
                        <h2>Account Information</h2>
                        <p><strong>Customer Name:</strong> {account.customerName}</p>
                        <p><strong>Account Number:</strong> {account.accountNumber}</p>
                        <p><strong>Balance:</strong> ${account.balance}</p>
                        <p><strong>Credit Score:</strong> {account.creditScore}</p>
                        <p><strong>Created At:</strong> {new Date(account.createdAt).toLocaleDateString()}</p>
                        <p><strong>Updated At:</strong> {new Date(account.updatedAt).toLocaleDateString()}</p>
                    </div>
                )}
            </div>
        </div>
    );
}