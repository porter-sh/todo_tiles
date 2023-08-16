import { Request, Response } from 'express';
import logger from '../../logger';
import Database from '../../database/Database';

const express = require('express');

export const tasksRouter = express.Router();

/**
 * Returns a user
 */
tasksRouter.get('/', (req: Request, res: Response) => {
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

    let tasks = Database.getTasks(userId, parsedCategoryId, parsedFilter,
        parsedTimeHorizon);

    res.send(tasks);
});

