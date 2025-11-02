import express from "express";
import path from "node:path";
import { fileURLToPath } from "node:url";

// Recreate __dirname manually (for ESM)
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const app = express();

app.get("/", (req, res) => {
    res.sendFile(path.join(__dirname, "index.html"));
});

app.listen(8000, () => {
    console.log("Server running on http://localhost:8000");
});

