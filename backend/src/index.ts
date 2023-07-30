import verifyUser from './api/util/auth';

const app = require('express')();
const PORT = 8080;

const { usersRouter } = require('./api/paths/users');

app.use(verifyUser);
app.use('/users', usersRouter);

app.listen(
    PORT,
    () => console.log(`Server is running on port ${PORT}.`)
)