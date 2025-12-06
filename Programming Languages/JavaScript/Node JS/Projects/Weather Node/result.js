import sendDataFromWeather from "./exp.js";

window.onload = async () => {
    const latitude = localStorage.getItem("latitude");
    const longitude = localStorage.getItem("longitude");

    const container = document.getElementById("weatherContainer");

    if (!latitude || !longitude) {
        container.innerHTML = "<p>Error: Missing coordinates.</p>";
        return;
    }

    container.innerHTML = "<h1>Fetching weather...</h1>";

    const res = await sendDataFromWeather(latitude, longitude);
    console.log(res.data)

    if (res.error) {
        container.innerHTML = `<p>Error fetching weather: ${res.error}</p>`;
        return;
    }

    // Example display
    container.innerHTML = `
        <h1>Weather Result</h1>
        <p><strong>Latitude:</strong> ${latitude}</p>
        <p><strong>Longitude:</strong> ${longitude}</p>
        <p><strong>Temperature:</strong> ${res.current?.temperature_2m ?? "N/A"}°C</p>
        <button onclick="window.location.href='index.html'">Go Back</button>
    `;
};
