import { BrowserRouter as Router, Routes, Route, Link } from 'react-router-dom';
import RegisterPage from './components/Register.jsx';
import LoginPage from './components/Login.jsx';


function App() {
	return (
        <Router>
            <div>
                <nav>
                    <ul>
                        <li>
                            <Link to="/register">Register</Link>
                        </li>
                        <li>
                            <Link to="/login">Login</Link>
                        </li>
                    </ul>
                </nav>

                <hr />

                <Routes>
                    <Route path="/register" element={<RegisterPage />} />
                    <Route path="/login" element={<LoginPage />} />
                </Routes>
            </div>
        </Router>
    )
}

export default App;
