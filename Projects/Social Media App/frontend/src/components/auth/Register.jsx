import React, { useState, useContext } from 'react';
import { TextField, Button, Typography } from '@mui/material';
import { AuthContext } from '../../context/AuthContext';

const Register = () => {
    const { register } = useContext(AuthContext);
    const [email, setEmail] = useState('');
    const [password, setPassword] = useState('');
    const [error, setError] = useState('');

    const handleSubmit = async (e) => {
        e.preventDefault();
        try {
            await register(email, password);
            // Redirect or show success message
        } catch (err) {
            setError(err.message);
        }
    };

    return (
        <div>
            <Typography variant="h4">Register</Typography>
            <form onSubmit={handleSubmit}>
                <TextField
                    label="Email"
                    type="email"
                    value={email}
                    onChange={(e) => setEmail(e.target.value)}
                    required
                />
                <TextField
                    label="Password"
                    type="password"
                    value={password}
                    onChange={(e) => setPassword(e.target.value)}
                    required
                />
                {error && <Typography color="error">{error}</Typography>}
                <Button type="submit" variant="contained" color="primary">
                    Register
                </Button>
            </form>
        </div>
    );
};

export default Register;