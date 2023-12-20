import express, { type Request, type Response } from "express";
import logger from "../../logger";
import Task from "../../database/Task";
import * as Database from "../../database/Database";

export const tasksRouter = express.Router();

/**
 * Returns all tasks for the current user that match the given filters.
 */
tasksRouter.get("/", async (req: Request, res: Response) => {
  const userId: string = req.decodedFirebaseToken.uid;
  const categoryId = req.query.categoryId;
  const filter = req.query.filter;
  const timeHorizon = req.query.timeHorizon;

  logger.http(
    `GET /tasks?categoryId=${categoryId}&filter=${filter}&timeHorizon=${timeHorizon}`,
  );

  let parsedCategoryId: number | undefined;
  try {
    parsedCategoryId = parseInt(categoryId as string);
  } catch {}
  const parsedFilter = Database.TaskFilter.fromString(
    (filter as string) || "all",
  );
  const parsedTimeHorizon = Database.TimeHorizon.fromString(
    (timeHorizon as string) || "all",
  );

  const tasks = await Database.getTasks(
    userId,
    parsedCategoryId,
    parsedFilter,
    parsedTimeHorizon,
  );

  res.send(tasks.map((task) => task.toJSON()));
});

/**
 * Creates a new task for the current user.
 */
tasksRouter.post("/", async (req: Request, res: Response) => {
  const userId: string = req.decodedFirebaseToken.uid;
  const name: string = req.body.name;
  const categoryId: number = req.body.category_id;
  const description: string = req.body.description;
  const dueDate: Date = req.body.due_date;
  const completionDate: Date = req.body.completion_date;

  logger.http(`POST /tasks, body: ${JSON.stringify(req.body)}`);

  const newTask = await Database.createTask(
    userId,
    name,
    categoryId,
    description,
    dueDate,
    completionDate,
  );

  res.send(newTask.toJSON());
});

/**
 * Updates a task for the current user.
 */
tasksRouter.put("/", async (req: Request, res: Response) => {
  const userId = req.decodedFirebaseToken.uid;

  logger.http(`PUT /tasks, body: ${JSON.stringify(req.body)}`);

  let updatedTask: Task;
  try {
    updatedTask = new Task(
      parseInt(req.body.id as string),
      req.body.user_id as string,
      parseInt(req.body.category_id as string),
      req.body.name as string,
      req.body.description as string | null,
      req.body.creation_date as string,
      req.body.due_date as string | null,
      req.body.completion_date as string | null,
    );

    logger.debug(`Parsed task: ${updatedTask.toString()}`);
  } catch (e) {
    logger.warn(`Failed to parse task: ${e}`);

    res.sendStatus(400);
    return;
  }

  if (userId !== updatedTask.userId) {
    logger.warn(
      `User [${userId}] attempted to update task [${updatedTask.id}] owned by user [${updatedTask.userId}].`,
    );
    res.sendStatus(403);
    return;
  }

  const newTask = await Database.updateTask(updatedTask);

  res.send(newTask.toJSON());
});

/**
 * Deletes a task for the current user.
 */
tasksRouter.delete("/:id", async (req: Request, res: Response) => {
  const userId: string = req.decodedFirebaseToken.uid;
  const taskId = req.params.id;

  logger.http(`DELETE /tasks/${taskId}`);

  let taskIdNum: number;
  try {
    taskIdNum = parseInt(taskId);
  } catch {
    res.sendStatus(400);
    return;
  }

  const deletedTask = await Database.deleteTask(userId, taskIdNum);

  res.send(deletedTask.toJSON());
});

/**
 * Mark a task as completed or not completed for the current user.
 */
tasksRouter.put("/:id/completed/", async (req: Request, res: Response) => {
  const userId: string = req.decodedFirebaseToken.uid;
  const taskId = req.params.id;
  const completed: string = req.body.completed;

  logger.http(
    `PUT /tasks/${taskId}/completed, body: ${JSON.stringify(req.body)}`,
  );

  let taskIdNum: number;
  try {
    taskIdNum = parseInt(taskId);
  } catch {
    res.sendStatus(400);
    return;
  }

  const updatedTask = await Database.setTaskCompleted(
    userId,
    taskIdNum,
    completed === "true",
  );

  res.send(updatedTask.toJSON());
});
