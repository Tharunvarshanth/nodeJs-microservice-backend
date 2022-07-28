import express, { json } from "express";
import { initializeDb } from "./src/model/db";
import { logger } from "./src/utils/logger";
import orderRoutes from "./src/routes";

const app = express();
//db connect
const db = initializeDb();

db.sequelize
  .sync({ force: true })
  .then(() => {
    logger.info("Synced db.");
  })
  .catch((err) => {
    logger.error("Failed to sync db: " + err.message);
  });

const port = 3000;
// parse requests of content-type - application/json
app.use(json());

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
  logger.info(`Up and Running on port ${port} - This is Book service`);
});
