import verifyUser from "./api/util/auth";
import logger from "./logger";
import Database from "./database/Database";

const https = require("https");
const fs = require("fs");
const express = require("express");
const app = express();
const PORT = 8080;

const { usersRouter } = require("./api/paths/users");
const { tasksRouter } = require("./api/paths/tasks");
const { testRouter } = require("./api/paths/test");

// Initialize the database
const db = new Database();

// Enable JSON parsing
app.use(express.json());

app.use(verifyUser);
app.use("/users", usersRouter);
app.use("/tasks", tasksRouter);
app.use("/test", testRouter);

// Read the certificate and key files
const privateKey = fs.readFileSync("server.key", "utf8");
const certificate = fs.readFileSync("server.cert", "utf8");

// Create an HTTPS server
const server = https.createServer({ key: privateKey, cert: certificate }, app);

// Listen to the HTTPS server
server.listen(PORT, () => logger.info(`Server is running on port ${PORT}.`));
