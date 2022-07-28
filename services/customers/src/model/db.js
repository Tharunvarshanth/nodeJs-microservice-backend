import { createConnection } from "mysql2/promise";
import { Sequelize } from "sequelize";
import { logger } from "../utils/logger";

const initializeDb = () => {
  const host = "localhost";
  const port = "3306";
  const user = "root";
  const password = "root";
  const database = "book-microservice";

  createConnection({ host, port, user, password })
    .then((con) => {
      con.query(`CREATE DATABASE IF NOT EXISTS \`${database}\`;`);
      logger.info("DB connected");
    })
    .catch((err) => {
      logger.info("DB not connected", err);
    });

  // connect to db
  const sequelize = new Sequelize(database, user, password, { dialect: "mysql" });

  // init models and add them to the exported db object
  const db = {};
  db.Sequelize = Sequelize;
  db.sequelize = sequelize;
  db.customer = require("./customer.model").default(sequelize, Sequelize);
  return db;
};
export { initializeDb };
