import React, {useState} from 'react';
function MyComponent() {
    const [name, setName] = useState("Sai");
	const [age, setAge] = useState(0);


    setTimeout(() => {
        setName("Saisakthi")
    }, 2000)

	
	

	return (
		<div>
			<p>name : {name}</p>
			<p>age : {age}</p>

		</div>
	);
}

export default MyComponent;