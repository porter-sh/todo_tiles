declare namespace Express {
    interface Request {
        decodedFirebaseToken?: DecodedIdToken;
    }
}