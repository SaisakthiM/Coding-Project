import styles from './quiz.module.css';
import { useState } from "react";

export default function Quiz({ Questions, Options, Answer, onAnswer, onNext }) {
  const [selected, setSelected] = useState(null);

  const handleSelect = (index) => {
    if(selected === null){
      setSelected(index);
      onAnswer(index === Answer);
    }
  };

  return (
    <div className={styles.container}>
      <h1>Quiz App</h1>
      <hr /> 
      <h2>{Questions}</h2>
      <ul>
        {Options.map((option, index) => (
          <li 
            key={index} 
            onClick={() => handleSelect(index)}
            className={selected === index ? styles.selected : ""}
          >
            {option}
          </li>
        ))}
      </ul>
      <div className={styles.button_quiz}>
        <button onClick={() => onNext(selected)}>Next</button>
      </div>
    </div>
  )
}
