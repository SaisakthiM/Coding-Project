import React, {useState} from 'react';
function MyComponent() {
    const [name, setName] = useState("Sai");

    setTimeout(() => {
        setName("Saisakthi")
    }, 2000)

	return (
		<div>
			<p>name : {name}</p>
		</div>
	);
}

export default MyComponent;