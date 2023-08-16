import { Request, Response } from 'express';
import logger from '../../logger';
import Database from '../../database/Database';

const express = require('express');

export const tasksRouter = express.Router();

/**
 * Returns all tasks for the current user that match the given filters.
 */
tasksRouter.get('/', async (req: Request, res: Response) => {
    const userId = req.decodedFirebaseToken.uid;
    const categoryId = req.query.categoryId;
    const filter = req.query.filter;
    const timeHorizon = req.query.timeHorizon;

    logger.http(`GET /tasks?categoryId=${categoryId}&filter=${filter}&timeHorizon=${timeHorizon}`);

    let parsedCategoryId: number | undefined;
    try {
        parsedCategoryId = parseInt(categoryId as string);
    } catch { }
    const parsedFilter = Database.TaskFilter.fromString(
        filter as string || 'all');
    const parsedTimeHorizon = Database.TimeHorizon.fromString(
        timeHorizon as string || 'all');

    let tasks = await Database.getTasks(userId, parsedCategoryId, parsedFilter,
        parsedTimeHorizon);

    res.send(tasks.map((task) => task.toJSON()));
});

/**
 * Creates a new task for the current user.
 */
tasksRouter.post('/', async (req: Request, res: Response) => {
    const userId = req.decodedFirebaseToken.uid;
    const name = req.body.name;
    const categoryId = req.body.category_id;
    const description = req.body.description;
    const dueDate = req.body.due_date;
    const completionDate = req.body.completion_date;

    logger.http(`POST /tasks, body: ${JSON.stringify(req.body)}`);

    let newTask = await Database.createTask(userId, name, categoryId, description, dueDate, completionDate);

    res.send(newTask.toJSON());
});