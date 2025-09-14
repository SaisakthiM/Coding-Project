import React, {useState} from 'react';
function MyComponent() {
    const [name, setName] = useState("Sai");
	const [age, setAge] = useState(0);

	
	return (
		<div>
			<p>name : {name}</p>
			<input type="text" placeholder="Enter your name" className='nameInput'/>
			<button onClick={setName(document.getElementsByClassName("nameInput").value)}>click to chane the name</button>
			<p>age : {age}</p>
			

		</div>
	);
}

export default MyComponent;