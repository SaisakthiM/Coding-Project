import { useState } from "react"
import Register from "./retriever.js"

export default async function Register() {
    let [user, setUser] = useState("");
    let [password, setPassword] = useState("");

    async function register(username, password) {
        let user = new Register(username, password);
        
    }

}