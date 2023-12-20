import express, { type Request, type Response } from "express";
import logger from "../../logger";
import * as Database from "../../database/Database";

export const testRouter = express.Router();

/**
 * Dummy endpoint for testing purposes.
 */
testRouter.get("/", async (req: Request, res: Response) => {
  logger.http(`GET /tasks`);

  // Database.deleteDatabase();
  void Database.test();

  logger.info("");
  res.send("Done.");
});
