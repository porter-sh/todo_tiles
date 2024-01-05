import express, { type Request, type Response } from "express";
import logger from "../../logger";
import Category from "../../database/Category";
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

/**
 * Updates a category for the current user.
 */
categoriesRouter.put("/:categoryId", async (req: Request, res: Response) => {
  const userId: string = req.decodedFirebaseToken.uid;
  const categoryId = parseInt(req.params.categoryId);

  logger.http(
    `PUT /categories/${categoryId}, body: ${JSON.stringify(req.body)}`,
  );

  let updatedCategory: Category;
  try {
    updatedCategory = new Category(
      parseInt(req.params.categoryId),
      req.body.userId as string,
      req.body.name as string,
      req.body.description as string | null,
      req.body.display_color as string | null,
    );
  } catch (e) {
    logger.warn(`Failed to parse category: ${e}`);

    res.sendStatus(400);
    return;
  }

  if (userId !== updatedCategory.userId) {
    logger.warn(
      `User ${userId} tried to update category ${categoryId} belonging to user ${updatedCategory.userId}`,
    );

    res.sendStatus(403);
    return;
  }

  const newCategory = await Database.updateCategory(updatedCategory);

  res.send(newCategory.toJSON());
});

/**
 * Deletes a category for the current user.
 */
categoriesRouter.delete("/:categoryId", async (req: Request, res: Response) => {
  const userId: string = req.decodedFirebaseToken.uid;
  const categoryId = parseInt(req.params.categoryId);

  logger.http(`DELETE /categories/${categoryId}`);

  const category = await Database.getCategory(categoryId);

  if (!category) {
    logger.warn(`Category ${categoryId} not found`);

    res.sendStatus(404);
    return;
  }

  const deletedCategory = await Database.deleteCategory(userId, categoryId);

  res.send(deletedCategory.toJSON());
});
