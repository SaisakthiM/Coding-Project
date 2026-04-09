import { useEffect, useState } from "react"
import axios from "axios"


export function Weather() {
    useEffect(() => {
        const res = axios.get("http:localhost:8000/");
        return res.data
    })
    const [Lat, setLat] = useState("");
    const [Lon, setLon] = useState("");
    const [Loc, setLoc] = useState("");
    return (
        <div className="wrapper">
            <div className="container">
                <h1>Weather API</h1>
                <br></br>
                <p>In this API, you have to fill the location and details of the area you are searching for</p>
                <p>Here are the details need to fill</p>
                <br></br>
                <form>
                    <label>Location : </label>
                    <input type="text" pattern="[A-Za-z]" value={Loc} onChange={(e) => {setLoc(e.target.value)}} ></input>
                    <br></br>
                    <br></br>
                    <label>Latitide : </label>
                    <input type="text" pattern="[A-Za-z]" value={Lat} onChange={(e) => {setLat(e.target.value)}} ></input>
                    <br></br>
                    <br></br>
                    <label>Longitude : </label>
                    <input type="text" pattern="[A-Za-z]" value={Lon} onChange={(e) => {setLon(e.target.value)}} ></input>
                    <br></br>
                    <br></br>
                    <input type="submit" id="sub_button"></input>
                </form>
            </div>
        </div>
    )
}