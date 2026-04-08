export function Weather() {
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
                    <input type="text" pattern="[A-Za-z]"></input>
                    <br></br>
                    <br></br>
                    <label>Latitude : </label>
                    <input type="text" pattern="[A-Za-z]"></input>
                    <br></br>
                    <br></br>
                    <label>Longitude : </label>
                    <input type="text" pattern="[A-Za-z]"></input>
                    <br></br>
                    <br></br>
                    <input type="submit" id="sub_button"></input>

                </form>
            </div>
        </div>
    )
}