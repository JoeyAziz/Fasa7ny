const express = require("express");
const router = express.Router();
const mysqlConnection = require("../app/database_connection"); //database connector

//---------------------AREA

//CREATE AREA
router.post("/area/create", (req, res) => {
  var country = req.body.country;
  var city = req.body.city;

  var query = "CALL CreateArea('" + country + "','" + city + "')";

  mysqlConnection.query(query, (err, results) => {
    if (!err) {
      return res.json({
        data: results
      });
    } else {
      console.log("coud not exec query because " + err);
    }
  });
});

//DELETE AREA
router.post("/area/delete", (req, res) => {
  var country = req.body.country;
  var city = req.body.city;

  var query = "CALL DeleteArea('" + country + "','" + city + "')";

  mysqlConnection.query(query, (err, results) => {
    if (!err) {
      return res.json({
        data: results
      });
    } else {
      console.log("coud not exec query because " + err);
    }
  });
});

//-----------------------LOCATION

//create location
router.post("/location/create", (req, res) => {
  var country = req.body.country;
  var city = req.body.city;
  var name = req.body.name;
  var budget = req.body.budget;
  var lat = req.body.lat;
  var lon = req.body.lon;

  var query =
    "CALL CreateLocation('" +
    country +
    "','" +
    city +
    "','" +
    name +
    "'," +
    budget +
    "," +
    lat +
    "," +
    lon +
    ")";

  mysqlConnection.query(query, (err, results) => {
    if (!err) {
      return res.json({
        data: results
      });
    } else {
      console.log("coud not exec query because " + err);
    }
  });
});

//Delete location
router.post("/location/delete", (req, res) => {
  var country = req.body.country;
  var city = req.body.city;
  var name = req.body.name;
  var lat = req.body.lat;
  var lon = req.body.lon;

  var query =
    "CALL DeleteLocation('" +
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
        data: results
      });
    } else {
      console.log("coud not exec query because " + err);
    }
  });
});

//-----------------------ADMIN

//MAKE/REMOVE ADMIN
router.post("/makeAdmin", (req, res) => {
  var email = req.body.email;
  var val = req.body.val;

  var query = "CALL SetUserAdmin('" + email + "'," + val + ")";

  mysqlConnection.query(query, (err, results) => {
    if (!err) {
      return res.json({
        data: results
      });
    } else {
      console.log("coud not exec query because " + err);
    }
  });
});

//GET ALL ADMINS
router.post("/getAdmins", (req, res) => {
  var query = "CALL GetAdmins()";

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

//Check if user is admin
router.get("/checkAdmin/:email", (req, res) => {
  var email = req.params.email;
  var query = "CALL GetAdmin('" + email + "')";

  mysqlConnection.query(query, (err, results) => {
    if (!err) {
      return res.json({
        data: results
      });
    } else {
      console.log("coud not exec query because " + err);
    }
  });
});

//GET ALL USERS
router.post("/getUsers", (req, res) => {
  var query = "CALL GetUsers()";

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
