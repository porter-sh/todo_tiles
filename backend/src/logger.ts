import winston from "winston";
import Transport from "winston-transport";

enum Colors {
  error = "\x1b[31m",
  warn = "\x1b[33m",
  info = "\x1b[32m",
  http = "\x1b[36m",
  debug = "\x1b[34m",
  silly = "\x1b[35m",
}

class ColorConsoleTrasport extends Transport {
  log(info: winston.Logform.TransformableInfo, callback: () => void) {
    setImmediate(() => {
      this.emit("logged", info);
    });

    const color = Colors[info.level as keyof typeof Colors];
    const timestamp = new Date().toISOString().substring(11, 19); // get the current timestamp in ISO format
    if (color) {
      console.log(
        `\x1b[90m[${timestamp}] ${color}${info.level}\x1b[0m: ${info.message}`,
      ); // add the timestamp before the level
    } else {
      console.log(`${timestamp} ${info.message}`); // add the timestamp before the message
    }

    callback();
  }
}

const logger = winston.createLogger({
  level: "debug",
  transports: [new ColorConsoleTrasport()],
});

export default logger;
