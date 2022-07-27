const express = require("express");
const db = require("./model/db");
const logger = require("./utils/logger");
const orderRoutes = require("./routes");

const app = express();
//db connect
db.sequelize
  .sync({ force: true })
  .then(() => {
    logger.info("Synced db.");
  })
  .catch((err) => {
    console.log("Failed to sync db: " + err.message);
  });

const port = 3000;
// parse requests of content-type - application/json
app.use(express.json());

app.use("/", orderRoutes);
app.use(function (req, res, next) {
  next(createError(404));
});

// error handler
app.use(function (err, req, res, next) {
  // set locals, only providing error in development
  res.locals.message = err.message;
  // res.locals.error = req.app.get('env') === 'development' ? err : {};
  // render the error page
  res.status(err.status || 500);
  res.render("error");
});

app.listen(port, () => {
  console.log(`Up and Running on port ${port} - This is Book service`);
});
