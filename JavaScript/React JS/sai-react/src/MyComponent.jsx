import React, {useState} from "react";
function MyComponent() {
    const [name, setname] = useState("Guest");
    const handleChangeName = (event) => setname(event.target.value);
    return (<div>
        <input onChange={handleChangeName}></input>
        <p>name : {name}</p>
    </div>)

}

export default MyComponent;