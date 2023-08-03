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

    if (id != req.decodedFirebaseToken.uid) {
        logger.warn(`Client requested user [${id}] but is authenticated with [${req.decodedFirebaseToken.uid}].`);

        throw new Error('Authentication token does not match user id.');
    }

    res.send(`Hello ${id}!`);
});

