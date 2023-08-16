import sqlite3 from 'sqlite3';
import Task from './Task';
import logger from '../logger';

enum Tables {
    users,
    categories,
    tasks,
}

enum TaskFilterEnum {
    // Do not filter tasks.
    all = 'all',
    // Only return completed tasks.
    complete = 'complete',
    // Only return incomplete tasks.
    incomplete = 'incomplete',
    // Only return tasks that were already due, but not completed.
    overdue = 'overdue',
    // Only return tasks that are due in the future.
    upcoming = 'upcoming',
}

class TaskFilter {
    public static readonly TaskFilterEnum = TaskFilterEnum;

    private filter: TaskFilterEnum;

    private constructor(filter: TaskFilterEnum) {
        this.filter = filter;
    }

    public static fromString(filter: string) {
        return new Database.TaskFilter(filter as TaskFilterEnum ||
            TaskFilterEnum.all);
    }

    public get displayString(): string {
        return this.filter;
    }

    public get sqlString(): string {
        switch (this.filter) {
            case TaskFilterEnum.all:
                return ``;
            case TaskFilterEnum.complete:
                return `completion_date_ IS NOT NULL`;
            case TaskFilterEnum.incomplete:
                return `completion_date_ IS NULL`;
            case TaskFilterEnum.overdue:
                return `due_date < datetime('now') AND completion_date IS NULL`;
            case TaskFilterEnum.upcoming:
                return `due_date >= datetime('now') AND completion_date IS NULL`;
        }
    }
}

enum TimeHorizonEnum {
    // Do not filter by due date.
    all = 'all',
    // Only return tasks due in the next day.
    day = 'day',
    // Only return tasks due in the next week.
    week = 'week',
    // Only return tasks due in the next month.
    month = 'month',
}

class TimeHorizon {
    public static readonly TimeHorizonEnum = TimeHorizonEnum;

    private timeHorizon: TimeHorizonEnum;

    private constructor(timeHorizon: TimeHorizonEnum) {
        this.timeHorizon = timeHorizon;
    }

    public static fromString(timeHorizon: string) {
        return new Database.TimeHorizon(timeHorizon as TimeHorizonEnum ||
            TimeHorizonEnum.all);
    }

    public get displayString(): string {
        return this.timeHorizon;
    }

    public get sqlString(): string {
        switch (this.timeHorizon) {
            case TimeHorizonEnum.all:
                return ``;
            case TimeHorizonEnum.day:
                return `due_date < datetime('now', '+1 day')`;
            case TimeHorizonEnum.week:
                return `due_date < datetime('now', '+1 week')`;
            case TimeHorizonEnum.month:
                return `due_date < datetime('now', '+1 month')`;
        }
    }
}

export default class Database {
    private static db: sqlite3.Database;

    public static readonly Tables = Tables;
    public static readonly TaskFilterEnum = TaskFilterEnum;
    public static readonly TaskFilter = TaskFilter;
    public static readonly TimeHorizonEnum = TimeHorizonEnum;
    public static readonly TimeHorizon = TimeHorizon;

    /**
     * Initialize the database.
     */
    constructor() {
        logger.info('Initializing the database.');

        Database.db = new sqlite3.Database('db.sqlite');

        // Create the categories table
        Database.db.run(`CREATE TABLE IF NOT EXISTS categories (
          id INTEGER PRIMARY KEY,
          user_id INTEGER NOT NULL,
          name TEXT NOT NULL,
          description TEXT
        )`);

        // Create the tasks table
        Database.db.run(`CREATE TABLE IF NOT EXISTS tasks (
          id INTEGER PRIMARY KEY,
          user_id INTEGER NOT NULL,
          category_id INTEGER,
          name TEXT NOT NULL,
          description TEXT,
          creation_date TEXT NOT NULL,
          due_date TEXT,
          completion_date TEXT,
          FOREIGN KEY (category_id) REFERENCES categories (id)
        )`);
    }

    /**
     * Get the tasks for a user, sorted by due date.
     * @param userId The user id.
     * @param categoryId The category id.
     * @param filter How to filter the tasks.
     * @param timeHorizon How far into the future to look for tasks.
     * @returns A promise that resolves to an array of tasks.
     */
    public static getTasks(userId: string, categoryId?: number,
        filter?: TaskFilter,
        timeHorizon?: TimeHorizon): Promise<Task[]> {
        logger.debug(`Getting tasks for user [${userId}], with category [${categoryId}], filter [${filter?.displayString}], and time horizon [${timeHorizon?.displayString}].`);

        return new Promise((resolve, reject) => {
            let sql = `SELECT * FROM tasks WHERE user_id = ?`;
            let params = [userId];

            if (categoryId) {
                sql += ` AND category_id = ?`;
                params.push(categoryId.toString());
            }

            if (filter !== undefined && filter.sqlString.length > 0) {
                sql += ` AND ${filter.sqlString}`;
            }

            if (timeHorizon !== undefined && timeHorizon.sqlString.length > 0) {
                sql += ` AND ${timeHorizon!.sqlString}`;
            }

            sql += ` ORDER BY due_date ASC`;

            logger.debug(`SQL: ${sql}, params: [${params}]`);

            Database.db.all(sql, params, (err, rows) => {
                if (err) {
                    logger.error(`Error getting tasks: ${err}`);
                    reject(err);
                } else {
                    let res = rows.map((row) => Task.fromRow(row));
                    logger.debug(`Found ${res.length} tasks.`);
                    resolve(res);
                }
            });
        });
    }

    /**
     * Get a task by id.
     * @param id The task id.
     * @returns A promise that resolves to the task.
    */
    public static getTask(id: number): Promise<Task> {
        logger.debug(`Getting task with id [${id}].`);

        return new Promise((resolve, reject) => {
            let sql = `SELECT * FROM tasks WHERE id = ?`;

            logger.debug(`SQL: ${sql}, params: [${id}]`);

            Database.db.get(sql, [id], (err, row) => {
                if (err) {
                    logger.error(`Error getting task: ${err}`);
                    reject(err);
                } else {
                    let res = Task.fromRow(row);
                    logger.debug(`Found task: ${res.toString()}`);
                    resolve(res);
                }
            });
        });
    }

    /**
     * Create a new task.
     * @param userId The user id.
     * @param categoryId The category id.
     * @param name The task name.
     * @param description The task description.
     * @param dueDate The task due date.
     * @returns A promise that resolves to the new task.
     */
    public static createTask(userId: string, name: string, categoryId?: number,
        description?: string, dueDate?: Date, completionDate?: Date):
        Promise<Task> {
        logger.debug(`Creating task for user [${userId}], with category [${categoryId}], name [${name}], description [${description}], due date [${dueDate}], and completion date [${completionDate}].`);

        return new Promise((resolve, reject) => {
            let sql = `INSERT INTO tasks (user_id, category_id, name, description, creation_date, due_date) VALUES (?, ?, ?, ?, datetime('now'), ?)`;
            let params = [userId, categoryId, name, description, dueDate];

            logger.debug(`SQL: ${sql}, params: [${params}]`);

            Database.db.run(sql, params, function (err) {
                if (err) {
                    logger.error(`Error creating task: ${err}`);
                    reject(err);
                } else {
                    logger.debug(`Created task with id [${this.lastID}].`);
                    resolve(this.lastID);
                }
            });
        }).then((id) => {
            return Database.getTask(id as number);
        });
    }
}

