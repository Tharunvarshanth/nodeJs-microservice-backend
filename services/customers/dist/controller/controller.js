"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.getUsers = getUsers;

function getUsers(req, res) {
  return res.status(200).send("Welcome to the customer service");
}