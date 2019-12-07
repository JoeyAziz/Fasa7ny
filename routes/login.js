const express = require("express");
const router = express.Router();
const mysqlConnection = require("../app/database_connection"); //database connector

//User Login
router.post("/", (req, res) => {
  var email = req.body.email;
  var pass = req.body.pass;

  var query = "CALL CheckPassword('" + email + "','" + pass + "')";

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

module.exports = router;
