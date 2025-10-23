import axios from "axios";

export default async function sendDataFromWeather(latitude, longitude) {
    const url = "https://api.openmeteo.com/v1/forecast";
    const params = {
        latitude : latitude,
        longitude : longitude
    }
    try {
        const res = await axios.get(url, {params})
        return res.data;
    }
    catch (err) {
        return { error: err.message };
    }

}