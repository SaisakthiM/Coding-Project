var express = require('express');
var router = express.Router();
var axios = require('axios')


/* GET home page. */

router.get("/", (req,res) => {
  console.log(req.query)
  res.send("hi")
})
router.get('/api/weather/', function(req, res, next) {
  res.send("Hello")
});

module.exports = router;
