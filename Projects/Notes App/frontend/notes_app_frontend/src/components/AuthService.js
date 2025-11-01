// AuthService.js
import axios from "axios";

export default class AuthService {
    constructor(username, password) {
        this.username = username;
        this.password = password;
    }

    async register() {
        const url = "http://127.0.0.1:8000/api/user/register/";
        const params = {
            username: this.username,
            password: this.password,
        };
        const headers = { "Content-Type": "application/json" };
        const response = await axios.post(url, params, { headers });
        return response.data;
    }

    async login() {
        const url = "http://127.0.0.1:8000/api/token/";
        const params = {
            username: this.username,
            password: this.password,
        };
        const headers = { "Content-Type": "application/json" };
        const response = await axios.post(url, params, { headers });
        return response.data;
    }
}
