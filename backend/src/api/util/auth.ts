import { Request, Response, NextFunction } from 'express';
import { DecodedIdToken } from 'firebase-admin/lib/auth/token-verifier';
import { getAuth } from 'firebase-admin/auth';
import admin from 'firebase-admin';
import logger from './logger';

const serviceAccountCreds = require('../../../serviceAccountKey.json');
const firebaseApp = admin.initializeApp({
    credential: admin.credential.cert(serviceAccountCreds),
});
const auth = getAuth(firebaseApp);

function tokenIsValid(token: string | undefined) {
    if (token === undefined || token.length === 0) {
        return false;
    }
    return true;
}

// Middleware to verify the user with firebase.
export default function verifyUser(req: Request, res: Response, next: NextFunction) {
    const token = req.get('Authorization');


    if (!tokenIsValid(token)) {
        res.status(401).send('Invalid token.');
        logger.warn(`Client tried to authenticate with invalid token: ${token}.`);
        return;
    }

    auth
        .verifyIdToken(token!)
        .then((decodedToken: DecodedIdToken) => {
            const uid = decodedToken.uid;
            logger.info(`Client is authenticated with uid ${uid}.`);
        })
        .catch((error: any) => {
            res.status(401).send('Invalid token.');
            logger.error(`Authentication error for token ${token}: ${error}`);
        });


    next();
}