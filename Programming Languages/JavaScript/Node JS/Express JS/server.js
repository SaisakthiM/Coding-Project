import "express"
import express from "express"

const app = express()

app.get('/main', (req, res) => {console.log("Hello")})

app.listen(3000, () => {
  console.log(`Example app listening on port ${port}`)
})

asdkasn  