import { Request, Response } from "express";
import logger from "../../logger";
import Database from "../../database/Database";
import Task from "../../database/Task";

const express = require("express");

export const testRouter = express.Router();

/**
 * Dummy endpoint for testing purposes.
 */
testRouter.get("/", async (req: Request, res: Response) => {
  logger.http(`GET /tasks`);

  // Database.deleteDatabase();
  Database.test();

  logger.info("");
  res.send("Done.");
});
