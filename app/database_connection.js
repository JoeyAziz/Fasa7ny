const mysql = require("mysql");
var config = require("config");

var mysqlConnection = mysql.createConnection(config.get("MySQL"));

//connect to database
mysqlConnection.connect(err => {
  if (!err) {
    //if succeeded
    console.log(
      "Connection to database ( " +
        config.get("MySQL.database") +
        " ) succeeded"
    );
  } else {
    //if connection failed
    console.log(
      "Connection to database ( " +
        config.get("MySQL.database") +
        " ) failed " +
        err
    );
  }
});

module.exports = mysqlConnection;
