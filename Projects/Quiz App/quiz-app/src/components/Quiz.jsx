import './quiz.css';
import { useState } from "react";

export default function Quiz({Questions, Options, Answer, Mark=false}) {
    const [selected, setSelected] = useState(null); // store which option user clicked
    const handleSelect = (index) => {
        if (selected === null) { // allow only one choice
            setSelected(index);
        }
    };
    if (selected === Answer) {
        Mark = true
    }
    else {
        Mark = false
    }
    return (<>
        <div className='container'>
            <h1>Quiz App</h1>
            <hr></hr> 
            <h2>1. {Questions}</h2>
            <ul>
                {Options.map(
                    (option,index) => (
                        <li key={index} onClick={() => handleSelect(index)} className={selected === index ? "selected" : ""}>{option}</li>
                    )
                )}
            </ul>
            <div className="button_quiz">
                <button>Next</button>
            </div>
            <div className='index'>
                <br></br>
                <p>1 of 5 Questions</p>
            </div>
        </div>
    </>)
}

