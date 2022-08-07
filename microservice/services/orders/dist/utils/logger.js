"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.logger = void 0;

var _winston = require("winston");

const logger = (0, _winston.createLogger)({
  transports: [new _winston.transports.Console({
    format: _winston.format.combine(_winston.format.timestamp({
      format: "MMM-DD-YYYY HH:mm:ss"
    }), _winston.format.align(), _winston.format.printf(info => `${info.level}:${[info.timestamp]}:${info.message}`))
  })]
});
exports.logger = logger;