import { Request, Response } from "express";
import logger from "../../logger";
import Database from "../../database/Database";
import Task from "../../database/Task";

const express = require("express");

export const categoriesRouter = express.Router();

/**
 * Returns all categories for the current user.
 */
categoriesRouter.get("/", async (req: Request, res: Response) => {
  const userId = req.decodedFirebaseToken.uid;

  logger.http(`GET /categories`);

  let categories = await Database.getCategories(userId);

  res.send(categories.map((category) => category.toJSON()));
});

/**
 * Creates a new category for the current user.
 */
categoriesRouter.post("/", async (req: Request, res: Response) => {
  const userId = req.decodedFirebaseToken.uid;
  const name = req.body.name;

  logger.http(`POST /categories, body: ${JSON.stringify(req.body)}`);

  let newCategory = await Database.createCategory(userId, name);

  res.send(newCategory.toJSON());
});
