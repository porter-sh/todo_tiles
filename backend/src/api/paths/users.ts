import { Request, Response } from 'express';
import logger from '../util/logger';

const express = require('express');
const users = require('../services/users');

export const usersRouter = express.Router();

/**
 * Returns a user
 */
usersRouter.get('/:id', (req: Request, res: Response) => {
    const id = req.params.id;

    logger.http(`GET /users/${id}`);

    let new_id: string = users.getUserById(id);
    res.send(new_id);
});

