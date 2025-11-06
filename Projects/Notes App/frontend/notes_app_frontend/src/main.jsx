import { StrictMode } from 'react';
import { createRoot } from 'react-dom/client';
import "./styles.css";
import App from './App.jsx';
import { UserProvider } from './components/UserProvider.jsx';

createRoot(document.getElementById('root')).render(
  <StrictMode>
    <UserProvider>    {/* ✅ use this */}
      <App />
    </UserProvider>
  </StrictMode>
);
