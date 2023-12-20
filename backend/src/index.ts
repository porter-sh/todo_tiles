import https from "https";
import fs from "fs";
import express from "express";

import verifyUser from "./api/util/auth";
import { usersRouter } from "./api/paths/users";
import { tasksRouter } from "./api/paths/tasks";
import { testRouter } from "./api/paths/test";
import logger from "./logger";

const app = express();
const PORT = 8080;

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
