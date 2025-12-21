import axios from 'axios';

// Base API URL
const API_BASE_URL = import.meta.env.VITE_API_URL || 'http://localhost:8080';

const bankService = {
  // Create new account
  createAccount: async (customerName, accountNumber) => {
    try {
      const response = await axios.post(`${API_BASE_URL}/api/accounts`, {
        customerName,
        accountNumber,
      });
      return response.data;
    } catch (error) {
      throw error.response?.data || error.message;
    }
  },

  // Get all accounts
  getAllAccounts: async () => {
    try {
      const response = await axios.get(`${API_BASE_URL}/api/accounts`);
      return response.data;
    } catch (error) {
      throw error.response?.data || error.message;
    }
  },

  // Get account by ID
  getAccountById: async (id) => {
    try {
      const response = await axios.get(`${API_BASE_URL}/api/accounts/${id}`);
      return response.data;
    } catch (error) {
      throw error.response?.data || error.message;
    }
  },

  // Deposit money
  deposit: async (accountId, amount) => {
    try {
      const response = await axios.post(`${API_BASE_URL}/api/accounts/${accountId}/deposit`, {
        amount,
      });
      return response.data;
    } catch (error) {
      throw error.response?.data || error.message;
    }
  },

  // Withdraw money
  withdraw: async (accountId, amount) => {
    try {
      const response = await axios.post(`${API_BASE_URL}/api/accounts/${accountId}/withdraw`, {
        amount,
      });
      return response.data;
    } catch (error) {
      throw error.response?.data || error.message;
    }
  },
};

export default bankService;