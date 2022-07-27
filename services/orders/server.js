const express = require("express");
const db = require("./model/db");
const logger = require("./utils/logger");

const app = express();

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

//db connect

app.listen(port, () => {
  console.log(`Up and Running on port ${port} - This is Book service`);
});
