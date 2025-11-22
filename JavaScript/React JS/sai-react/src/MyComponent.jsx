import React, {useState} from "react";
import { use } from "react";
function MyComponent() {
    const [name, setname] = useState("Guest");
    const [quantity, setQuantity] = useState(0);
    const handleChangeName = (event) => setname(event.target.value);
    return (<div>
        <input onChange={handleChangeName}></input>
        <p>name : {name}</p>
        <input value={quantity} onChange={(e) => setQuantity(e.target.value)} type="number"></input>
        <p>Qunatity : {quantity}</p>
    </div>)

}

export default MyComponent;