import { Request, Response } from 'express';

const express = require('express');
const users = require('../services/users');

export const usersRouter = express.Router();

/**
 * Returns a user
 */
usersRouter.get('/:id', (req: Request, res: Response) => {
    let new_id: string = users.getUserById(req.params.id);
    res.send(new_id);
});

