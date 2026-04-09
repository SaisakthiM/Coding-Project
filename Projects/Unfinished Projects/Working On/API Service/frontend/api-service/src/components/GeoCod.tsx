import { useEffect, useState } from "react"
import axios from "axios"

export function GeoCod() {
    const [City, setCity] = useState("");
    const [State, setState] = useState("");
    const [Country, setCountry] = useState("");
    const [serverOnline, setServerOnline] = useState<boolean | null>(null);
    const [response, setResponse] = useState("")

    const send = async () => {
        try {
            const res = await axios.get(`http://localhost:8000/api/geo/cod/?city=${City}&state_code=${State}&country_code=${Country}`)
            setResponse(res.data)
        }
        catch (e) {
            console.log(e)
        }
    }

    useEffect(() => {
        const check = async () => {
            try {
                const res = await axios.get("http://localhost:8000/");
                setServerOnline(res.status === 200);
            } catch {
                setServerOnline(false);
            }
        };
        check();
    }, []);

    // Still waiting for server response
    if (serverOnline === null) {
        return <div>Checking server...</div>;
    }

    if (serverOnline) {
        return (
            <>
                <div className="wrapper">
                    <div className="container">
                        <h1>Geocoding API</h1>
                        <br />
                        <p>In this API, you have to fill the city name, state and country code. </p>
                        <p>then you will get the latitude and longitude code</p>
                        <p>Here are the details need to fill</p>
                        <br />
                        <form>
                            <label>City Name : </label>
                            <input type="text" value={City} onChange={(e) => setCity(e.target.value)} />
                            <br /><br />
                            <label>State Code : </label>
                            <input type="number" value={State} onChange={(e) => setState(e.target.value)} />
                            <br /><br />
                            <label>Country Code : </label>
                            <input type="number" value={Country} onChange={(e) => setCountry(e.target.value)} />
                            <br /><br />
                            <input type="submit" id="sub_button" onClick={send} value="Submit"/>
                        </form>
                        <br></br>
                    <div className="response">
                        <p>Latitude and Longitude : {response}</p>
                    </div>
                    </div>
                    
                </div>
            </>
        );
    }

    return (
        <div>
            <h2>400</h2>
            <p>Server Not Found</p>
        </div>
    );
}