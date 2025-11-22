import styles from './Button.module.css'
import { useState } from 'react';

function Button() {
    /*
	const styles = {
    backgroundColor: "rgb(0, 26, 255)",
	border: "none",
	borderRadius: "15px",
	width: "80px",
	height: "40px",
	color : "hsl(162, 65%, 55%)",
    }
	*/
	const [count, setCount] = useState(0);
	const handleClick = () => {
		setCount(prev => {
		if (prev + 1 > 10) {
			console.log("Don't Click Me");
			console.log(`Your name is ${name}`);
		} else {
			console.log("OUCH!");
		}
		return prev + 1;
		});
	};

	return (
		<button onClick={handleClick} className={styles.Button}>
		Click me ({count})
		</button>
	);
}
export default Button