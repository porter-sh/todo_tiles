import sqlite3 from "sqlite3";
import Task from "./Task";
import Category from "./Category";
import logger from "../logger";

export enum Tables {
  users,
  categories,
  tasks,
}

export enum TaskFilterEnum {
  // Do not filter tasks.
  all = "all",
  // Only return completed tasks.
  complete = "complete",
  // Only return incomplete tasks.
  incomplete = "incomplete",
  // Only return tasks that were already due, but not completed.
  overdue = "overdue",
  // Only return tasks that are due in the future.
  upcoming = "upcoming",
}

export class TaskFilter {
  public static readonly TaskFilterEnum = TaskFilterEnum;

  private readonly filter: TaskFilterEnum;

  private constructor(filter: TaskFilterEnum) {
    this.filter = filter;
  }

  public static fromString(filter: string): TaskFilter {
    return new TaskFilter((filter as TaskFilterEnum) || TaskFilterEnum.all);
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

export enum TimeHorizonEnum {
  // Do not filter by due date.
  all = "all",
  // Only return tasks due in the next day.
  day = "day",
  // Only return tasks due in the next week.
  week = "week",
  // Only return tasks due in the next month.
  month = "month",
}

export class TimeHorizon {
  public static readonly TimeHorizonEnum = TimeHorizonEnum;

  private readonly timeHorizon: TimeHorizonEnum;

  private constructor(timeHorizon: TimeHorizonEnum) {
    this.timeHorizon = timeHorizon;
  }

  public static fromString(timeHorizon: string): TimeHorizon {
    return new TimeHorizon(
      (timeHorizon as TimeHorizonEnum) || TimeHorizonEnum.all,
    );
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

// Initialize the database
logger.info("[DATABASE] Initializing the database.");
const db: sqlite3.Database = new sqlite3.Database("db.sqlite");

// Create the categories table
db.run(`CREATE TABLE IF NOT EXISTS categories (
        id INTEGER PRIMARY KEY,
        user_id INTEGER NOT NULL,
        name TEXT NOT NULL,
        description TEXT,
        display_color TEXT
    )`);

// Create the tasks table
db.run(`CREATE TABLE IF NOT EXISTS tasks (
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

/**
 * Delete the database.
 */
export function deleteDatabase(): void {
  logger.info("[DATABASE] Deleting the database.");

  db.run(`DROP TABLE IF EXISTS categories; DROP TABLE IF EXISTS tasks;`);
}

/**
 * Dummy function for testing.
 */
export async function test(): Promise<void> {
  logger.debug(`[DATABASE] Running test.`);

  const sql = `SELECT * FROM categories`;

  logger.debug(`[DATABASE] SQL: ${sql}`);

  db.all(sql, (err, rows) => {
    if (err) {
      logger.error(`[DATABASE] Error running test: ${err}`);
      throw err;
    }

    logger.debug(
      `[DATABASE] Found ${rows.length} rows: ${rows.map((row) => {
        return "\n" + Task.fromRow(row).toString();
      })}`,
    );
  });
}

/**
 * Get the tasks for a user, sorted by due date.
 * @param userId The user id.
 * @param categoryId The category id.
 * @param filter How to filter the tasks.
 * @param timeHorizon How far into the future to look for tasks.
 * @returns A promise that resolves to an array of tasks.
 */
export async function getTasks(
  userId: string,
  categoryId?: number,
  filter?: TaskFilter,
  timeHorizon?: TimeHorizon,
): Promise<Task[]> {
  logger.debug(
    `[DATABASE] Getting tasks for user [${userId}], with category [${categoryId}], filter [${filter?.displayString}], and time horizon [${timeHorizon?.displayString}].`,
  );

  let sql = `SELECT * FROM tasks WHERE user_id = ?`;
  const params = [userId];

  if (categoryId) {
    sql += ` AND category_id = ?`;
    params.push(categoryId.toString());
  }

  if (filter !== undefined && filter.sqlString.length > 0) {
    sql += ` AND ${filter.sqlString}`;
  }

  if (timeHorizon !== undefined && timeHorizon.sqlString.length > 0) {
    sql += ` AND ${timeHorizon.sqlString}`;
  }

  sql += ` ORDER BY due_date ASC`;

  logger.debug(`[DATABASE] SQL: ${sql}, params: [${params}]`);

  return await new Promise((resolve, reject) => {
    db.all(sql, params, (err, rows) => {
      if (err) {
        logger.error(`[DATABASE] Error getting tasks: ${err}`);
        reject(err);
      }

      const res = rows.map((row) => Task.fromRow(row));
      logger.debug(`[DATABASE] Found ${res.length} tasks.`);
      resolve(res);
    });
  });
}

/**
 * Get a task by id.
 * @param id The task id.
 * @returns A promise that resolves to the task.
 */
export async function getTask(id: number): Promise<Task> {
  logger.debug(`[DATABASE] Getting task with id [${id}].`);

  const sql = `SELECT * FROM tasks WHERE id = ?`;

  logger.debug(`[DATABASE] SQL: ${sql}, params: [${id}]`);

  return await new Promise((resolve, reject) =>
    db.get(sql, [id], (err, row) => {
      if (err) {
        logger.error(`[DATABASE] Error getting task: ${err}`);
        throw err;
      }

      const res = Task.fromRow(row);
      logger.debug(`[DATABASE] Found task: ${res.toString()}`);
      return res;
    }),
  );
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
export async function createTask(
  userId: string,
  name: string,
  categoryId?: number,
  description?: string,
  dueDate?: Date,
  completionDate?: Date,
): Promise<Task> {
  logger.debug(
    `[DATABASE] Creating task for user [${userId}], with category [${categoryId}], name [${name}], description [${description}], due date [${dueDate}], and completion date [${completionDate}].`,
  );

  const sql = `INSERT INTO tasks (user_id, category_id, name, description, creation_date, due_date) VALUES (?, ?, ?, ?, datetime('now'), ?)`;
  const params = [userId, categoryId, name, description, dueDate];

  logger.debug(`[DATABASE] SQL: ${sql}, params: [${params}]`);
  return await new Promise((resolve, reject) => {
    db.run(sql, params, function (err) {
      if (err) {
        logger.error(`[DATABASE] Error creating task: ${err}`);
        reject(err);
      }

      logger.debug(`[DATABASE] Created task with id [${this.lastID}].`);
      resolve(getTask(this.lastID));
    });
  });
}

/**
 * Update a task.
 * @param task The updated version of the task. The id is invariant.
 * @returns A promise that resolves when the task is updated.
 */
export async function updateTask(task: Task): Promise<Task> {
  logger.debug(`[DATABASE] Updating task [${task.toString()}].`);

  const sql = `UPDATE tasks SET category_id = ?, name = ?, description = ?, due_date = ?, completion_date = ? WHERE id = ?`;
  const params = [
    task.categoryId,
    task.name,
    task.description,
    task.dueDate,
    task.completionDate,
    task.id,
  ];

  logger.debug(`[DATABASE] SQL: ${sql}, params: [${params}]`);
  return await new Promise<Task>((resolve, reject) => {
    db.run(sql, params, (err) => {
      if (err) {
        logger.error(`[DATABASE] Error updating task: ${err}`);
        reject(err);
      }

      logger.debug(`[DATABASE] Updated task.`);
      resolve(getTask(task.id));
    });
  });
}

/**
 * Delete a task.
 * @param userId The user id.
 * @param id The task id.
 * @returns A promise that resolves when the task is deleted.
 */
export async function deleteTask(userId: string, id: number): Promise<Task> {
  logger.debug(`[DATABASE] Deleting task [${id}].`);

  const sql = `DELETE FROM tasks WHERE id = ? AND user_id = ?`;
  const params = [id, userId];

  logger.debug(`[DATABASE] SQL: ${sql}, params: [${params}]`);

  return await new Promise<Task>((resolve, reject) => {
    db.run(sql, params, (err) => {
      if (err) {
        logger.error(`[DATABASE] Error deleting task: ${err}`);
        reject(err);
      }
      logger.debug(`[DATABASE] Deleted task.`);
      resolve(getTask(id));
    });
  });
}

/**
 * Mark a task as completed or not completed.
 * @param userId The user id.
 * @param id The task id.
 * @param completed Whether the task is completed.
 * @returns A promise that resolves when the task is updated.
 */
export async function setTaskCompleted(
  userId: string,
  id: number,
  completed: boolean,
): Promise<Task> {
  logger.debug(`[DATABASE] Setting task [${id}] to completion [${completed}].`);

  let sql = ``;
  if (completed) {
    sql = `UPDATE tasks SET completion_date = datetime('now') WHERE id = ? AND user_id = ?`;
  } else {
    sql = `UPDATE tasks SET completion_date = NULL WHERE id = ? AND user_id = ?`;
  }
  const params = [id, userId];

  logger.debug(`SQL: ${sql}, params: [${params}]`);
  return await new Promise<Task>((resolve, reject) => {
    db.run(sql, params, (err) => {
      if (err) {
        logger.error(`[DATABASE] Error setting task completion: ${err}.`);
        reject(err);
      }

      logger.debug(`[DATABASE] Set task completion: ${completed}.`);
      resolve(getTask(id));
    });
  });
}

/**
 * Get the categories for a user sorted alphabetically.
 * @param userId The user id.
 * @returns A promise that resolves to an array of categories.
 */
export async function getCategories(userId: string): Promise<Category[]> {
  logger.debug(`[DATABASE] Getting categories for user [${userId}].`);

  const sql = `SELECT * FROM categories WHERE user_id = ? ORDER BY name ASC`;

  logger.debug(`[DATABASE] SQL: ${sql}, params: [${userId}]`);

  return await new Promise((resolve, reject) => {
    db.all(sql, [userId], (err, rows) => {
      if (err) {
        logger.error(`[DATABASE] Error getting categories: ${err}`);
        reject(err);
      }

      const res = rows.map((row) => Category.fromRow(row));
      logger.debug(`[DATABASE] Found ${res.length} categories.`);
      resolve(res);
    });
  });
}

/**
 * Get a category by id.
 * @param id The category id.
 * @returns A promise that resolves to the category.
 */
export async function getCategory(id: number): Promise<Category> {
  logger.debug(`[DATABASE] Getting category with id [${id}].`);

  const sql = `SELECT * FROM categories WHERE id = ?`;

  logger.debug(`[DATABASE] SQL: ${sql}, params: [${id}]`);

  return await new Promise((resolve, reject) => {
    db.get(sql, [id], (err, row) => {
      if (err) {
        logger.error(`[DATABASE] Error getting category: ${err}`);
        reject(err);
      }
      const res = Category.fromRow(row);
      logger.debug(`[DATABASE] Found category: ${res.toString()}`);
      resolve(res);
    });
  });
}

/**
 * Create a new category.
 * @param userId The user id.
 * @param name The category name.
 * @param description The category description.
 * @param displayColor The category display color.
 * @returns A promise that resolves to the new category.
 */
export async function createCategory(
  userId: string,
  name: string,
  description?: string,
  displayColor?: string,
): Promise<Category> {
  logger.debug(
    `[DATABASE] Creating category for user [${userId}], name [${name}], description [${description}], and display color [${displayColor}].`,
  );

  const sql = `INSERT INTO categories (user_id, name, description, display_color) VALUES (?, ?, ?, ?)`;
  const params = [userId, name, description, displayColor];

  logger.debug(`[DATABASE] SQL: ${sql}, params: [${params}]`);

  return await new Promise((resolve, reject) => {
    db.run(sql, params, function (err) {
      if (err) {
        logger.error(`[DATABASE] Error creating category: ${err}`);
        reject(err);
      }
      logger.debug(`[DATABASE] Created category with id [${this.lastID}].`);
      resolve(getCategory(this.lastID));
    });
  });
}

/**
 * Update a category.
 * @param category The updated version of the category. The id is invariant.
 * @returns A promise that resolves when the category is updated.
 */
export async function updateCategory(category: Category): Promise<Category> {
  logger.debug(`[DATABASE] Updating category [${category.toString()}].`);

  const sql = `UPDATE categories SET name = ?, description = ?, display_color = ? WHERE id = ?`;
  const params = [category.name, category.description, category.displayColor];

  logger.debug(`[DATABASE] SQL: ${sql}, params: [${params}]`);

  return await new Promise((resolve, reject) => {
    db.run(sql, params, (err) => {
      if (err) {
        logger.error(`[DATABASE] Error updating category: ${err}`);
        reject(err);
      }
      logger.debug(`[DATABASE] Updated category.`);
      resolve(getCategory(category.id));
    });
  });
}

/**
 * Delete a category.
 * @param userId The user id.
 * @param id The category id.
 * @returns A promise that resolves when the category is deleted.
 */
export async function deleteCategory(
  userId: string,
  id: number,
): Promise<Category> {
  logger.debug(`[DATABASE] Deleting category [${id}].`);

  const toReturn = getCategory(id);

  const sql = `DELETE FROM categories WHERE id = ? AND user_id = ?`;
  const params = [id, userId];

  logger.debug(`[DATABASE] SQL: ${sql}, params: [${params}]`);

  return await new Promise((resolve, reject) => {
    db.run(sql, params, (err) => {
      if (err) {
        logger.error(`[DATABASE] Error deleting category: ${err}`);
        reject(err);
      }
      logger.debug(`[DATABASE] Deleted category.`);
      resolve(toReturn);
    });
  });
}
