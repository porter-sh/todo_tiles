import { Request, Response } from "express";
import logger from "../../logger";
import Database from "../../database/Database";
import Task from "../../database/Task";

const express = require("express");

export const tasksRouter = express.Router();

/**
 * Returns all tasks for the current user that match the given filters.
 */
tasksRouter.get("/", async (req: Request, res: Response) => {
  const userId = req.decodedFirebaseToken.uid;
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

  let tasks = await Database.getTasks(
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
  const userId = req.decodedFirebaseToken.uid;
  const name = req.body.name;
  const categoryId = req.body.category_id;
  const description = req.body.description;
  const dueDate = req.body.due_date;
  const completionDate = req.body.completion_date;

  logger.http(`POST /tasks, body: ${JSON.stringify(req.body)}`);

  let newTask = await Database.createTask(
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
      parseInt(req.body.id),
      req.body.user_id,
      parseInt(req.body.category_id),
      req.body.name,
      req.body.description,
      req.body.creation_date,
      req.body.due_date,
      req.body.completion_date,
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

  let newTask = await Database.updateTask(updatedTask);

  res.send(newTask.toJSON());
});

/**
 * Deletes a task for the current user.
 */
tasksRouter.delete("/:id", async (req: Request, res: Response) => {
  const userId = req.decodedFirebaseToken.uid;
  const taskId = req.params.id;

  logger.http(`DELETE /tasks/${taskId}`);

  let taskIdNum: number;
  try {
    taskIdNum = parseInt(taskId);
  } catch {
    res.sendStatus(400);
    return;
  }

  let deletedTask = await Database.deleteTask(userId, taskIdNum);

  res.send(deletedTask.toJSON());
});

/**
 * Mark a task as completed or not completed for the current user.
 */
tasksRouter.put("/:id/completed/", async (req: Request, res: Response) => {
  const userId = req.decodedFirebaseToken.uid;
  const taskId = req.params.id;
  const completed = req.body.completed;

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

  let updatedTask = await Database.setTaskCompleted(
    userId,
    taskIdNum,
    completed,
  );

  res.send(updatedTask.toJSON());
});
