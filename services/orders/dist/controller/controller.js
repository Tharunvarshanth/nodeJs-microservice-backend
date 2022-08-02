"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.getOrders = getOrders;

function getOrders(req, res) {
  return res.status(200).send("Welcome to the order service");
}