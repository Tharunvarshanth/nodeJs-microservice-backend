const mysql = require("mysql2/promise");
const { Sequelize } = require("sequelize");

//initializeDb();

//async function initializeDb() {
// create db if it doesn't already exist
// const { host, port, user, password, database } = config.database;
const host = "localhost";
const port = "3306";
const user = "root";
const password = "root";
const database = "book-microservice";

mysql
  .createConnection({ host, port, user, password })
  .then((con) => {
    con.query(`CREATE DATABASE IF NOT EXISTS \`${database}\`;`);
    console.log("DB connected");
  })
  .catch((err) => {
    console.log("DB not connected", err);
  });

// connect to db
const sequelize = new Sequelize(database, user, password, { dialect: "mysql" });

// init models and add them to the exported db object
const db = {};
db.Sequelize = Sequelize;
db.sequelize = sequelize;
db.order = require("./order.model")(sequelize, Sequelize);
module.exports = db;

// sync all models with database
//}
