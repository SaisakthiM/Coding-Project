var express = require('express');
var router = express.Router();
var axios = require('axios')
const { loadEnvFile } = require('node:process');
loadEnvFile('/home/saisakthi/Coding-Project/Projects/Unfinished Projects/Working On/API Service/backend/bin/.env');

/* GET home page. */

router.get("/", (req,res) => {
  console.log(req.query)
  res.send("Server")
})
router.get('/api/weather/', async function(req, res, next) {
  const { lat, lon } = req.query;
  const val = await axios.get(
    `https://api.openweathermap.org/data/2.5/weather?lat=${lat}&lon=${lon}&appid=${process.env.API_KEY_WEATHER}&units=metric`
  );
  res.json(val.data);
});

// Fix: add trailing slash to match frontend
router.get('/api/geo/cod/', async function(req, res, next) {
  const { city, state_code, country_code } = req.query;
  const val = await axios.get(
    `http://api.openweathermap.org/geo/1.0/direct?q=${city},${state_code},${country_code}&appid=${process.env.API_KEY_WEATHER}`
  );
  res.json(val.data);
});


module.exports = router;
