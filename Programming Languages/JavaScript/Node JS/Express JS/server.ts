import express from "express";

const app: any = express();
app.get('/main', (req: any, res: any) => {res.send("hello")})

