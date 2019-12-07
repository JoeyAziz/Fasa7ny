const express = require("express");
const router = express.Router();
const mysqlConnection = require("../app/database_connection"); //database connector

//get All countries
router.post("/getCountries", (req, res) => {
  var query = "CALL getCountries()";

  mysqlConnection.query(query, (err, results) => {
    if (!err) {
      return res.json({
        data: results[0]
      });
    } else {
      console.log("coud not exec query because " + err);
    }
  });
});

//get All cities
router.post("/getCities", (req, res) => {
  var query = "CALL getCities()";

  mysqlConnection.query(query, (err, results) => {
    if (!err) {
      return res.json({
        data: results[0]
      });
    } else {
      console.log("coud not exec query because " + err);
    }
  });
});

//get cities in a country
router.post("/getCitiesInCountry", (req, res) => {
  var country = req.body.country;

  var query = "CALL GetCitiesWithinCountry('" + country + "')";

  mysqlConnection.query(query, (err, results) => {
    if (!err) {
      return res.json({
        data: results[0]
      });
    } else {
      console.log("coud not exec query because " + err);
    }
  });
});

//Get Location
router.post("/getLocationInfo", (req, res) => {
  var country = req.body.country;
  var city = req.body.city;
  var name = req.body.name;
  var lat = req.body.lat;
  var lon = req.body.lon;

  var query =
    "CALL getLocation('" +
    country +
    "','" +
    city +
    "','" +
    name +
    "'," +
    lat +
    "," +
    lon +
    ")";

  mysqlConnection.query(query, (err, results) => {
    if (!err) {
      return res.json({
        data: results[0]
      });
    } else {
      console.log("coud not exec query because " + err);
    }
  });
});

module.exports = router;
