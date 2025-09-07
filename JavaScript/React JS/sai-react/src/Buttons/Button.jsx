import { useState } from 'react';
import styles from './Button.module.css';

function Button({name}) {
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

export default Button;
