import express from "express";

let app = express();

app.get("/", (req, res) => {
    res.send("Hi I am sai");
})

app.listen(8000, () => {
    console.log("hi")
})

