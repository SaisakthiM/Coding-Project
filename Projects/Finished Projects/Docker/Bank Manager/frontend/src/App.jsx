import { BrowserRouter, Routes, Route } from "react-router-dom";
import Welcome from "./components/Welcome.jsx";
import AddDeposit from "./components/AddDeposit.jsx";
import Withdraw from "./components/Withdraw.jsx";
import GetAccount from "./components/GetAccount.jsx";
import Loan from "./components/Loan.jsx";
import Repay from "./components/Repay.jsx";
import "./style.css";

function App() {
    return (
        <BrowserRouter>
            <Routes>
                <Route path="/" element={<Welcome />} />
                <Route path="/add" element={<AddDeposit />} />
                <Route path="/withdraw" element={<Withdraw />} />
                <Route path="/account" element={<GetAccount />} />
                <Route path="/loan" element={<Loan />} />
                <Route path="/repay" element={<Repay />} />
            </Routes>
        </BrowserRouter>
    );
}

export default App;