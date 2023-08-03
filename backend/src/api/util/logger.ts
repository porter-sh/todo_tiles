import winston from 'winston';

// Logger format
const format = winston.format.printf(
    (info: winston.Logform.TransformableInfo) => {
        return `[${info.timestamp}] ${info.level.toUpperCase()}: ${info.message}`;
    });

const logger = winston.createLogger({
    level: 'info',
    format: winston.format.combine(
        winston.format.timestamp({ format: 'HH:mm:ss' }),
        format
    ),
    transports: [new winston.transports.Console()],
});

export default logger;
