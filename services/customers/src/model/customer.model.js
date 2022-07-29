import { Sequelize, DataTypes, Model } from "sequelize";

export default (sequelize, Sequelize) => {
  const Customer = sequelize.define("customer", {
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
  return Customer;
};
