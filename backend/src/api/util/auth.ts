import { Request, Response, NextFunction } from "express";
import { DecodedIdToken } from "firebase-admin/lib/auth/token-verifier";
import { getAuth } from "firebase-admin/auth";
import admin from "firebase-admin";
import logger from "../../logger";

const serviceAccountCreds = require("../../../serviceAccountKey.json");
const firebaseApp = admin.initializeApp({
  credential: admin.credential.cert(serviceAccountCreds),
});
const auth = getAuth(firebaseApp);

// Middleware to verify the user with firebase.
export default async function verifyUser(
  req: Request,
  res: Response,
  next: NextFunction,
) {
  const token = req.get("Authorization");
  logger.debug(`Authenticating with token ${token}.`);

  if (token === undefined || token.length === 0) {
    logger.warn(`Client did not provide authentication token.`);

    return next(new Error("No authentication token provided."));
  }

  try {
    req.decodedFirebaseToken = await auth.verifyIdToken(token!);
    const uid = req.decodedFirebaseToken.uid;
    logger.info(`Client is authenticated with uid [${uid}].`);
  } catch (error) {
    logger.error(`Authentication error for token [${token}]: \n${error}`);

    return next(error);
  }

  next();
}
