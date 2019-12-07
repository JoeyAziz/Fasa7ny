const express = require("express");
const router = express.Router();
const mysqlConnection = require("../app/database_connection"); //database connector

//GetLocationsWithBudget
router.post("/GetLocationsWithBudget", (req, res) => {
  var budget = req.body.budget;
  var query = "CALL GetLocationsWithBudget('" + budget + "')";

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

//GetLocationsWithBudgetInArea
router.post("/GetLocationsWithBudgetInArea", (req, res) => {
  var country = req.body.country;
  var city = req.body.city;
  var budget = req.body.budget;
  var query =
    "CALL GetLocationsWithBudgetInArea('" +
    country +
    "','" +
    city +
    "'," +
    budget +
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

//GET LOCATION
router.post("/getLocation", (req, res) => {
  var country = req.body.country;
  var city = req.body.city;
  var name = req.body.name;
  var lat = req.body.lat;
  var lon = req.body.lon;
  var query =
    "CALL getLocation('" + country + "','" + city + "','" + name + "',";
  lat + "," + lon + ")";
  console.log(query);
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
