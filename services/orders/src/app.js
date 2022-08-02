import express, { json } from "express";
import { initializeDb } from "./model/db";
import { logger } from "./utils/logger";
import orderRoutes from "./handler/routes";

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

app.use("/api/orders", orderRoutes);
app.use(function (req, res, next) {
  next(createError(404));
});

// error handler
app.use(function (err, req, res, next) {
  logger.info(req._parsedUrl.href);
  res.locals.message = err.message;
  logger.info(err.message);
  res.status(err.status || 404);
  res.json({
    message: err.message,
    error: err,
  });
});

app.listen(port, () => {
  logger.info(`Up and Running on port ${port} - This is Book service`);
});
