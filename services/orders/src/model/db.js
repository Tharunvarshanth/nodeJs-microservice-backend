import { createConnection } from "mysql2/promise";
import { Sequelize } from "sequelize";

//initializeDb();

const initializeDb = () => {
  const host = "localhost";
  const port = "3306";
  const user = "root";
  const password = "root";
  const database = "book-microservice";

  createConnection({ host, port, user, password })
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
  db.order = require("./order.model").default(sequelize, Sequelize);
  return db;
};
export { initializeDb };
