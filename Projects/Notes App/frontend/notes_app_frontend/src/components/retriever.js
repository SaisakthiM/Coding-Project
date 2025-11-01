
import axios from "axios";

class Register {
    constructor(username, password) {
        this .username = username
        this.password = password
    }
    async register() {
        let url = "http://127.0.0.1:8000/api/user/register/";
        let params = {
            username: this.username,
            password : this.password,
            
        }
        let headers = {
                "Content-Type" : "application/json",
        }
        let response = await axios.post(url, params, {headers});
        return (response.data)
    }
    async get_token() {
        let url = "http://127.0.0.1:8000/api/token/";
        let params = {
            username: this.username,
            password : this.password,
            
        }
        let headers = {
                "Content-Type" : "application/json",
        }
        let response = await axios.post(url, params, {headers});
        return (response.data)
    }
}


