import './quiz.css'

export default function Quiz() {
    return (<>
        <div className='container'>
            <h1>Quiz App</h1>
            <hr></hr> 
            <h2>Which device is required for a internet connection ?</h2>
            <ul>
                <li>Modem</li>
                <li>Router</li>
                <li>LAN Cable</li>
                <li>Pen Drive</li>
            </ul>
            <button>Next</button>
            
            <div className='index'>
                <br></br>
                <p>1 of 5 Questions</p>
            </div>
        </div>
    </>)
}

