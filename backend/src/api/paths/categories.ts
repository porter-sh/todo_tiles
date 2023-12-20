import express, { type Request, type Response } from "express";
import logger from "../../logger";
import * as Database from "../../database/Database";

export const categoriesRouter = express.Router();

/**
 * Returns all categories for the current user.
 */
categoriesRouter.get("/", async (req: Request, res: Response) => {
  const userId: string = req.decodedFirebaseToken.uid;

  logger.http(`GET /categories`);

  const categories = await Database.getCategories(userId);

  res.send(categories.map((category) => category.toJSON()));
});

/**
 * Creates a new category for the current user.
 */
categoriesRouter.post("/", async (req: Request, res: Response) => {
  const userId: string = req.decodedFirebaseToken.uid;
  const name: string = req.body.name;

  logger.http(`POST /categories, body: ${JSON.stringify(req.body)}`);

  const newCategory = await Database.createCategory(userId, name);

  res.send(newCategory.toJSON());
});
