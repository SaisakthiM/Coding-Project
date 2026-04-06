import "/home/saisakthi/Coding-Project/Projects/Unfinished Projects/Working On/API Service/frontend/api-service/src/css/Home.css"
import { Link } from "react-router-dom"


export function Home() {
    return (
        <div className="wrapper">
            <div className="container">
                    <br></br>
                    <br></br>
                    <br></br>
                    <h1>API Service</h1>
                    <br></br>
                    <br></br>
                    <p>This service enables for fetching multiple API calls at the time</p>
                    <p>Here are the list we currently have in our service</p>
                    <br></br>
                    <br></br>
                    <div className="list_api">
                    <ol>
                        <li><Link to="/api/weather">Weather API</Link></li>
                        <li><Link to="/api/geo">Geolocation API</Link></li>
                    </ol>
                </div>
            </div>
            
        </div>
    )
}