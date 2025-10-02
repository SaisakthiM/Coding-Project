import './quiz.css'

export default function Quiz({Questions, Options, Answer}) {
    return (<>
        <div className='container'>
            <h1>Quiz App</h1>
            <hr></hr> 
            <h2>1. {Questions}</h2>
            <ul>
                <li>{Options[0]}</li>
                <li>{Options[1]}</li>
                <li>{Options[2]}</li>
                <li>{Options[3]}</li>
                
            </ul>
            <button>Next</button>
            
            <div className='index'>
                <br></br>
                <p>1 of 5 Questions</p>
            </div>
        </div>
    </>)
}

