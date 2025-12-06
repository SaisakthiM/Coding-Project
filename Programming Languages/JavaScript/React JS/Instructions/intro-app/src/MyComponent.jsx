import React, { useState } from 'react';

function MyComponent() {
    const [name, setName] = useState("Sai");
    const [age, setAge] = useState(0);
    const [employed, setEmployed] = useState(false);
    const [input, getInput] = useState('');

    const incrementAge = () => setAge(age + 1);

    return (
        <div>
            <p>Name: {name}</p>
            <input 
                type="text" 
                placeholder="Enter your name" 
                value={input} 
                onChange={(e) => getInput(e.target.value)} 
                className='nameInput'
            />
            <button className='input_box' onClick={() => setName(input)}>
                Click to change the name
            </button>

            <p>Age: {age}</p>
            <button onClick={incrementAge}>Increment Age</button>

            <p>Employed: {employed.toString()}</p>
            <button onClick={() => setEmployed(!employed)}>Change Employment Status</button>
        </div>
    );
}

export default MyComponent;