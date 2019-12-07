const express = require("express");
const router = express.Router();
const mysqlConnection = require("../app/database_connection"); //database connector

//Send
router.post("/", (req, res) => {
  var email = req.body.email;
  var pass = req.body.pass;
  var f_name = req.body.fname;
  var l_name = req.body.lname;

  var query =
    "CALL CreateUser('" +
    email +
    "','" +
    pass +
    "','" +
    f_name +
    "','" +
    l_name +
    "')";
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
