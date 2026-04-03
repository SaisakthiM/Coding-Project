import "express"
import express from "express"

const app = express()

app.get('/main',(req, res) => {res.send("hello")})

app.post('/main',(req, res) => {res.send("hello")})

app.put('/main',(req, res) => {res.send("hello")})

app.delete('/main',(req, res) => {res.send("hello")})

app.listen(3000, () => {
})

