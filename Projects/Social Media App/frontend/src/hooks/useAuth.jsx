import { useContext, useState } from 'react';
import { AuthContext } from '../context/AuthContext';

const useAuth = () => {
    const { login, logout, user } = useContext(AuthContext);
    const [error, setError] = useState(null);

    const handleLogin = async (credentials) => {
        try {
            await login(credentials);
            setError(null);
        } catch (err) {
            setError(err.message);
        }
    };

    const handleLogout = async () => {
        await logout();
    };

    return {
        user,
        error,
        handleLogin,
        handleLogout,
    };
};

export default useAuth;