"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.default = void 0;

var _sequelize = require("sequelize");

var _default = (sequelize, Sequelize) => {
  const Customer = sequelize.define("customer", {
    customerId: {
      type: _sequelize.DataTypes.BIGINT,
      allowNull: false
    },
    status: {
      type: _sequelize.DataTypes.STRING
    },
    orderedDate: {
      type: _sequelize.DataTypes.DATE
    }
  });
  return Customer;
};

exports.default = _default;