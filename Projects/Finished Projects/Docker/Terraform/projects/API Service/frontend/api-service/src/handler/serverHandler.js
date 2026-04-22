import axios from "axios"


export default async function serverCheck() {
    const res = await axios.get("http://localhost:8000");
    console.log(res.status)
}
serverCheck()