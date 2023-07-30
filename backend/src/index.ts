import verifyUser from './api/util/auth';

const https = require('https');
const fs = require('fs');
const app = require('express')();
const PORT = 8080;

const { usersRouter } = require('./api/paths/users');

app.use(verifyUser);
app.use('/users', usersRouter);

// Read the certificate and key files
const privateKey = fs.readFileSync('server.key', 'utf8');
const certificate = fs.readFileSync('server.cert', 'utf8');

// Create an HTTPS server
const server = https.createServer({ key: privateKey, cert: certificate }, app);

// Listen to the HTTPS server
server.listen(PORT, () => console.log(`Server is running on port ${PORT}.`));