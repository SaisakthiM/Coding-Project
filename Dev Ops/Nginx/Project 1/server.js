import express from "express";
import path from "path";
import { fileURLToPath } from "url";

const main_app = process.env.APP_NAME;

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const app = express();

app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, "index.html"));
})

app.listen(8000, () => {
    console.log("HI")
})
