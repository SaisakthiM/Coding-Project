import { useNavigate } from "react-router-dom"
import { useAuth } from "../context/AuthContext"

export default function Welcome() {
  const navigate = useNavigate()
  const { user, logout } = useAuth()

  function handleLogout() {
    logout()
    navigate("/login")
  }

  return (
    <div className="wrapper">
      <div className="container">
        <h1>Welcome, {user?.username}!</h1>
        <div className="account-details">
          <h2>Your Account Details</h2>
          <p><strong>Account Number:</strong> {user?.accountNumber}</p>
          <p><strong>Balance:</strong> ₹{user?.balance?.toLocaleString() ?? 0}</p>
          <p><strong>Credit Score:</strong> {user?.creditScore}</p>
          <p><strong>Loan Balance:</strong> ₹{user?.loanBalance?.toLocaleString() ?? 0}</p>
        </div>
        <h3>What would you like to do?</h3>
        <ol>
          <li><button onClick={() => navigate('/add')}>Add a Deposit</button></li>
          <li><button onClick={() => navigate('/withdraw')}>Withdraw from Deposit</button></li>
          <li><button onClick={() => navigate('/account')}>Get Account Details</button></li>
          <li><button onClick={() => navigate('/loan')}>Take a Loan</button></li>
          <li><button onClick={() => navigate('/repay')}>Repay Credit/Loan</button></li>
        </ol>
        <div className="button-group">
          <button onClick={handleLogout}>Logout</button>
        </div>
      </div>
    </div>
  )
}