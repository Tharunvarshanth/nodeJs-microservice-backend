"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.initializeDb = void 0;

var _promise = require("mysql2/promise");

var _sequelize = require("sequelize");

var _logger = require("../utils/logger");

const initializeDb = () => {
  const host = "localhost";
  const port = "3306";
  const user = "root";
  const password = "root";
  const database = "book-microservice";
  (0, _promise.createConnection)({
    host,
    port,
    user,
    password
  }).then(con => {
    con.query(`CREATE DATABASE IF NOT EXISTS \`${database}\`;`);

    _logger.logger.info("DB connected");
  }).catch(err => {
    _logger.logger.info("DB not connected", err);
  }); // connect to db

  const sequelize = new _sequelize.Sequelize(database, user, password, {
    dialect: "mysql"
  }); // init models and add them to the exported db object

  const db = {};
  db.Sequelize = _sequelize.Sequelize;
  db.sequelize = sequelize;
  db.order = require("./order.model").default(sequelize, _sequelize.Sequelize);
  return db;
};

exports.initializeDb = initializeDb;