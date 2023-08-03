import logger from '../util/logger';

module.exports.getUserById = (param: string) => {
    logger.debug(`getUserById(${param})`);

    return `Hello ${param}!`;
}
