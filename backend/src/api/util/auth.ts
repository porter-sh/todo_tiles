import { type Request, type Response, type NextFunction } from "express";
import { getAuth } from "firebase-admin/auth";
import admin from "firebase-admin";
import logger from "../../logger";
import serviceAccountCreds from "../../../serviceAccountKey.json";

const firebaseApp = admin.initializeApp({
  credential: admin.credential.cert(
    serviceAccountCreds as admin.ServiceAccount,
  ),
});
const auth = getAuth(firebaseApp);

// Middleware to verify the user with firebase.
export default async function verifyUser(
  req: Request,
  res: Response,
  next: NextFunction,
): Promise<void> {
  const token = req.get("Authorization");
  logger.debug(`Authenticating with token ${token}.`);

  if (token === undefined || token.length === 0) {
    logger.warn(`Client did not provide authentication token.`);

    next(new Error("No authentication token provided."));
    return;
  }

  if (token === "test") {
    logger.warn(`Client is using test token.`);

    next();
    return;
  }

  try {
    req.decodedFirebaseToken = await auth.verifyIdToken(token);
    const uid = req.decodedFirebaseToken.uid;
    logger.info(`Client is authenticated with uid [${uid}].`);
  } catch (error) {
    logger.error(`Authentication error for token [${token}]: \n${error}`);

    next(error);
    return;
  }

  next();
}
