// LoginPage.test.jsx
import { render, screen, fireEvent, waitFor } from '@testing-library/react';
import '@testing-library/jest-dom';
import { MemoryRouter } from 'react-router-dom';
import LoginPage from '../components/LoginPage';
import { loginUser } from '../api/authServices.js';

// Mock dependencies
vi.mock('../api/authServices.js');
vi.mock('../components/AuthContext.jsx', () => ({
    default: () => ({
        loginSuccess: vi.fn()
    })
}));
vi.mock('react-router-dom', () => ({
    ...vi.requireActual('react-router-dom'),
    useNavigate: () => vi.fn()
}));

describe('LoginPage', () => {

    beforeEach(() => {
        vi.clearAllMocks();
    });

    test('renders login form correctly', () => {
        render(<MemoryRouter><LoginPage /></MemoryRouter>);
        expect(screen.getByText('Login')).toBeInTheDocument();
        expect(screen.getByPlaceholderText('Username')).toBeInTheDocument();
        expect(screen.getByPlaceholderText('Password')).toBeInTheDocument();
        expect(screen.getByText('Login', { selector: 'button' })).toBeInTheDocument();
        expect(screen.getByText('Go to Register')).toBeInTheDocument();
    });

    test('typing updates username and password fields', () => {
        render(<MemoryRouter><LoginPage /></MemoryRouter>);

        fireEvent.change(screen.getByPlaceholderText('Username'), {
            target: { value: 'testuser' }
        });
        fireEvent.change(screen.getByPlaceholderText('Password'), {
            target: { value: 'TestPass123!' }
        });

        expect(screen.getByPlaceholderText('Username')).toHaveValue('testuser');
        expect(screen.getByPlaceholderText('Password')).toHaveValue('TestPass123!');
    });

    test('shows loading state while logging in', async () => {
        loginUser.mockReturnValue(new Promise(() => {})); // never resolves

        render(<MemoryRouter><LoginPage /></MemoryRouter>);

        fireEvent.click(screen.getByText('Login', { selector: 'button' }));

        expect(screen.getByText('Logging in...')).toBeInTheDocument();
        expect(screen.getByText('Logging in...')).toBeDisabled();
    });

    test('shows success message on successful login', async () => {
        loginUser.mockResolvedValue({ access: 'token123', refresh: 'refresh123' });

        render(<MemoryRouter><LoginPage /></MemoryRouter>);

        fireEvent.change(screen.getByPlaceholderText('Username'), {
            target: { value: 'testuser' }
        });
        fireEvent.change(screen.getByPlaceholderText('Password'), {
            target: { value: 'TestPass123!' }
        });
        fireEvent.click(screen.getByText('Login', { selector: 'button' }));

        await waitFor(() => {
            expect(screen.getByText('Login successful!')).toBeInTheDocument();
        });
    });

    test('shows error message on failed login', async () => {
        loginUser.mockRejectedValue({
            response: { data: 'Invalid credentials' }
        });

        render(<MemoryRouter><LoginPage /></MemoryRouter>);

        fireEvent.click(screen.getByText('Login', { selector: 'button' }));

        await waitFor(() => {
            expect(screen.getByText(/"Invalid credentials"/)).toBeInTheDocument();
        });
    });

    test('shows fallback error message when no response data', async () => {
        loginUser.mockRejectedValue(new Error('Network error'));

        render(<MemoryRouter><LoginPage /></MemoryRouter>);
        fireEvent.click(screen.getByText('Login', { selector: 'button' }));

        await waitFor(() => {
            expect(screen.getByText('Network error')).toBeInTheDocument();
        });
    });
});