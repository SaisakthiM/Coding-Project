var express = require('express');
var router = express.Router();
var axios = require('axios')


/* GET home page. */

router.get("/", (req,res) => {
  console.log(req.query)
  res.send("Server")
})
router.get('/api/weather/', async function(req, res, next) {
  const { pd, lat, lon } = req.query;
  const val = await axios.get(`https://api.openweathermap.org/data/2.5/weather?lat=${lat}&lon=${lon}&appid={a9dba91e24c88d7a4cdd395211df339a}`);
  res.json(val.data);
  console.log(val.data)
});
router.get('/api/geo/cod', async function(req, res, next) {
  const { city, state_code, country_code } = req.query;
  const val = await axios.get(`http://api.openweathermap.org/geo/1.0/direct?q=${city},${state_code},${country_code}&appid={69d7567a99a21895740382olsa305f0}`);
  res.json(val.data);
  console.log(val.data)
});


module.exports = router;
