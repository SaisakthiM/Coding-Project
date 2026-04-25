import axios from "axios"


export default async function serverCheck() {
    const res = await axios.get("/api-service/api/");
    console.log(res.status)
}
serverCheck()