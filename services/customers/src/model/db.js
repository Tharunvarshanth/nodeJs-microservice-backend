import { createConnection } from "mysql2/promise";
import { Sequelize } from "sequelize";
import { logger } from "../utils/logger";
import {Config} from '../env/config';

const initializeDb = () => {
  const host = Config.db.host;
  const port =  Config.db.port;
  const user =  Config.db.username;
  const password = Config.db.password;
  const database =  Config.db.database;

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
