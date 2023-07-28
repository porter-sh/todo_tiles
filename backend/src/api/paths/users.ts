import { Request, Response } from 'express';

const express = require('express');
const users = require('../services/users');

export const usersRouter = express.Router();

/**
 * Returns a user
 */
usersRouter.get('/:id', (req: Request, res: Response) => {
    users.getUserById(req.params.id);
});

