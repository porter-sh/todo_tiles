import { Request, Response, NextFunction } from 'express';
import { DecodedIdToken } from 'firebase-admin/lib/auth/token-verifier';
import { getAuth } from 'firebase-admin/auth';
import admin from 'firebase-admin';

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
    const token = req.get('Auth');

    if (!tokenIsValid(token)) {
        res.status(401).send('Invalid token.');
        console.log('Invalid token.');
        return;
    }

    auth
        .verifyIdToken(token!)
        .then((decodedToken: DecodedIdToken) => {
            const uid = decodedToken.uid;
            console.log(uid);
        })
        .catch((error: any) => {
            console.log(error);
        });


    next();
}