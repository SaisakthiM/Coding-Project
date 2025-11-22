import { useState } from "react";

function Supermarket() {
    const [name, setName] = useState("")
    const [password, setPassword] = useState("");
    return (
        <div>
            <form className="form_login"method="POST">
                <label>Enter Username : {name}</label>
                <br></br>
                <input type="text" onChange={(e) => setName(e.target.value)}></input>
                <br></br>
                <br></br>
                <label>Enter Password : {}</label>
                <br></br>
                <input type="password" onChange={(e) => setPassword(e.target.value)} ></input>
                <br></br>
                <br></br>
                <button type="submit">submit</button>
            </form>
        </div>
    );
}

export default Supermarket;