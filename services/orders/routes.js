const express = require("express");
const router = express.Router();
const orderController = require("./controller");

router.get("/", orderController.getOrders);
module.exports = router;
