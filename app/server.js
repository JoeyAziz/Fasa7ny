//libs
const express = require("express");
const bodyParser = require("body-parser");
const config = require("config");
const mysqlConnection = require("../app/database_connection"); //database connector

//defining routes
const usersRoutes = require("../routes/user");
const adminRoutes = require("../routes/admin");
const loginRoutes = require("../routes/login");
const registerRoutes = require("../routes/register");
const areaRoutes = require("../routes/area");
const fasahnyRoutes = require("../routes/fasahny");

//variabless
const port = config.get("App.webServer.port"); //port number for server
var app = express();

//extract the entire body portion of an incoming request stream
app.use(bodyParser.json());

//EntryPoint
app.post("/", (req, res) => res.json());

//using routes
app.use("/user", usersRoutes);
app.use("/admin", adminRoutes);
app.use("/login", loginRoutes);
app.use("/register", registerRoutes);
app.use("/area", areaRoutes);
app.use("/fasahny", fasahnyRoutes);

//listen to port number
app.listen(port, () => {
  console.log("listening on port " + port);
});
