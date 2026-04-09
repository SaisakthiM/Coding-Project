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
                    <p>Note: Weather API needs code in Latitude and longitude so use </p>
                    <p>Geocoding API to first convert your location into coordinates</p>
                    <br></br>
                    <br></br>
                    <div className="list_api">
                    <ol>
                        <li><Link to="/geo/cod">Geocoding API</Link></li>
                        <li><Link to="/weather">Weather API</Link></li>
                        <li><Link to="/geo/loc">Geolocation API</Link></li>
                    </ol>
                    <div className="result">
                        
                    </div>
                </div>
            </div>
            
        </div>
    )
}