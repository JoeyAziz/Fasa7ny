const express = require("express");
//const config = require("config");
const router = express.Router();
const mysqlConnection = require("../app/database_connection"); //database connector

//Request
router.get("/:email", (req, res) => {
  var email = req.params.email;

  mysqlConnection.query("CALL GetUser('" + email + "')", (err, results) => {
    if (!err) {
      return res.json({
        data: results[0]
      });
    } else {
      return res.send("Its empty now :)");
    }
  });
});

//Delete
router.post("/delete", (req, res) => {
  var email = req.body.email;
  var pass = req.body.pass;
  console.log(req.body);
  var query = "CALL DeleteUser('" + email + "','" + pass + "')";
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

//add user fav. locations
router.post("/favourite/location", (req, res) => {
  var email = req.body.email;
  var loc_id = req.body.loc_id;

  var query = "CALL addUserFavLocations('" + email + "','" + loc_id + "')";
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

//get user fav. locations
router.post("/favourite/get", (req, res) => {
  var email = req.body.email;

  var query = "CALL GetUserFavLocations('" + email + "')";
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
