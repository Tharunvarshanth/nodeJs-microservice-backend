export const Config = {
  app: {
    port: process.env.PORT || 3000,
  },
  db: {
    username: process.env.DB_USER || '',
    password: process.env.DB_PASSWORD || '',
    host: process.env.DB_HOST || '',
    port: process.env.DB_PORT || 3306,
    database: "booking_microservice"
  }
}