"use strict";

var _express = _interopRequireWildcard(require("express"));

var _db = require("./model/db");

var _logger = require("./utils/logger");

var _routes = _interopRequireDefault(require("./handler/routes"));

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

function _getRequireWildcardCache(nodeInterop) { if (typeof WeakMap !== "function") return null; var cacheBabelInterop = new WeakMap(); var cacheNodeInterop = new WeakMap(); return (_getRequireWildcardCache = function (nodeInterop) { return nodeInterop ? cacheNodeInterop : cacheBabelInterop; })(nodeInterop); }

function _interopRequireWildcard(obj, nodeInterop) { if (!nodeInterop && obj && obj.__esModule) { return obj; } if (obj === null || typeof obj !== "object" && typeof obj !== "function") { return { default: obj }; } var cache = _getRequireWildcardCache(nodeInterop); if (cache && cache.has(obj)) { return cache.get(obj); } var newObj = {}; var hasPropertyDescriptor = Object.defineProperty && Object.getOwnPropertyDescriptor; for (var key in obj) { if (key !== "default" && Object.prototype.hasOwnProperty.call(obj, key)) { var desc = hasPropertyDescriptor ? Object.getOwnPropertyDescriptor(obj, key) : null; if (desc && (desc.get || desc.set)) { Object.defineProperty(newObj, key, desc); } else { newObj[key] = obj[key]; } } } newObj.default = obj; if (cache) { cache.set(obj, newObj); } return newObj; }

const app = (0, _express.default)();
const db = (0, _db.initializeDb)();
db.sequelize.sync().then(() => {
  _logger.logger.info("DB connected");
}).catch(() => {
  _logger.logger.error("DB not connected");
});
app.use((0, _express.json)());
app.use("/", _routes.default);
app.use(function (req, res, next) {
  next(createError(404));
}); // error handler

app.use(function (err, req, res, next) {
  // set locals, only providing error in development
  res.locals.message = err.message; // res.locals.error = req.app.get('env') === 'development' ? err : {};
  // render the error page

  res.status(err.status || 500);
  res.render("error");
});
const port = 3001;
app.listen(port, () => {
  _logger.logger.info(`Up and Running on port ${port} - This is Book service`);
});