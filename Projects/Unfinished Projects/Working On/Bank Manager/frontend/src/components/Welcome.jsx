import { useNavigate } from "react-router-dom";

export default function Welcome() {
    const navigate = useNavigate();
    
    return (
        <div className="wrapper">
            <div className="container">
                <h1>Welcome to Bank Manager Application</h1>
                <h3>Here in the bank you can do the following things</h3>
                <ol>
                    <li><button onClick={() => navigate('/add')}>Add a Deposit</button></li>
                    <li><button onClick={() => navigate('/withdraw')}>Withdraw from Deposit</button></li>
                    <li><button onClick={() => navigate('/account')}>Get Account Details</button></li>
                    <li><button onClick={() => navigate('/loan')}>Take a Loan</button></li>
                    <li><button onClick={() => navigate('/repay')}>Repay Credit/Loan</button></li>
                </ol>
                <h1>Enjoy your Experience</h1>
            </div>
        </div>
    );
}