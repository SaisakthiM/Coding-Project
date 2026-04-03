import express from "express"
import { fileURLToPath } from 'url';
import { dirname } from 'path';
import path from "path"

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);


const app = express()

app.use(express.static('public'))

app.use('/static', express.static(path.join(__dirname, 'public')))

app.get('/main',(req, res) => {res.send("hello")})

app.post('/main',(req, res) => {res.send("hello")})

app.put('/main',(req, res) => {res.send("hello")})

app.delete('/main',(req, res) => {res.send("hello")})

app.listen(3000, () => {
})

