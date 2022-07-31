import express, { json } from "express";
import { initializeDb } from "./model/db";
import { logger } from "./utils/logger";
import customerRouter from "./handler/routes";

const app = express();

const db = initializeDb();
db.sequelize
  .sync()
  .then(() => {
    logger.info("DB connected");
  })
  .catch(() => {
    logger.error("DB not connected");
  });

app.use(json());
app.use("/", customerRouter);
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
const port = 3000;
app.listen(port, () => {
  logger.info(`Up and Running on port ${port} - This is Book service`);
});
