import winston from 'winston';
import Transport from 'winston-transport';

enum Colors {
    error = "\x1b[31m",
    warn = "\x1b[33m",
    info = "\x1b[32m",
    http = "\x1b[36m",
    debug = "\x1b[34m",
    silly = "\x1b[35m",
};

class ColorConsoleTrasport extends Transport {
    log(info: winston.Logform.TransformableInfo, callback: () => void) {
        setImmediate(() => {
            this.emit('logged', info);
        });

        const color = Colors[info.level as keyof typeof Colors];
        if (color) {
            console.log(color, info.message);
        } else {
            console.log(info.message);
        }

        callback();
    }
}

// Logger format
const format = winston.format.printf(
    (info: winston.Logform.TransformableInfo) => {
        return `[${info.timestamp}] ${info.level.toUpperCase()}: ${info.message}`;
    });

const logger = winston.createLogger({
    level: 'debug',
    format: winston.format.combine(
        winston.format.timestamp({ format: 'HH:mm:ss' }),
        format
    ),
    transports: [new ColorConsoleTrasport()],
});

export default logger;
