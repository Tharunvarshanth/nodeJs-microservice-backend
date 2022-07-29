import { Sequelize, DataTypes, Model } from "sequelize";

export default (sequelize, Sequelize) => {
  const Order = sequelize.define("orders", {
    customerId: {
      type: DataTypes.BIGINT,
      allowNull: false,
    },
    status: {
      type: DataTypes.STRING,
    },
    orderedDate: {
      type: DataTypes.DATE,
    },
  });
  return Order;
};
