import { createLogger, transports as _transports, format as _format } from "winston";

export const logger = createLogger({
  transports: [
    new _transports.Console({
      format: _format.combine(
        _format.timestamp({ format: "MMM-DD-YYYY HH:mm:ss" }),
        _format.align(),
        _format.printf((info) => `${info.level}:${[info.timestamp]}:${info.message}`)
      ),
    }),
  ],
});
