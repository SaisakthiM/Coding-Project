
export default async function serverCheck() {
    const res = await axios.get("http://localhost:8000");
    if (res.data == "Server") {
        return "Running"
    }
    else {
        return "Not Running"
    }
}
