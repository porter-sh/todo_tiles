/// This file contains the class that stores the data for the app. Eventually,
/// this should be responsible for interacting with a database, but for now, it
/// just stores the data in memory.

import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'types/category.dart';
import 'types/task.dart';

/// Public class [TaskData] is a [ChangeNotifier] that stores the data for the
/// app.
class TaskData with ChangeNotifier {
  /// Constructor to initialize the database connection.
  TaskData() {
    _initDatabase();
  }

  /// The database connection.
  late final Database _database;

  /// Initialize the database connection.
  Future<void> _initDatabase() async {
    final Future<Database> database = openDatabase(
      join(await getDatabasesPath(), 'todo_database.db'),
      onCreate: (db, version) {
        // Create the tasks table with columns for all Task fields.
        db.execute(
          '''CREATE TABLE tasks(
            id INTEGER PRIMARY KEY,
            name TEXT,
            description TEXT,
            category TEXT,
            dueDate TEXT,
            creationDate TEXT,
            completionDate TEXT
          )''',
        );
        // Create the categories table with columns for all Category fields.
        db.execute(
          '''CREATE TABLE categories(
            id INTEGER PRIMARY KEY,
            name TEXT,
            description TEXT,
            color TEXT
          )''',
        );
      },
      version: 1,
    );

    _database = await database;

    // Load the categories from the database.
    final List<Map<String, dynamic>> categoryMaps =
        await _database.query('categories');
    _categories = categoryMaps
        .map((categoryMap) => Category.fromMap(categoryMap))
        .toList();

    // Load the tasks from the database.
    final List<Map<String, dynamic>> taskMaps = await _database.query('tasks');
    // Change the category field of each map from a string to the corresponding
    // Category object from _categories if it exists. Otherwise, use
    // Category.none.
    _tasks = taskMaps
        .map((taskMap) => Task.fromMap(
              taskMap,
              _categories.firstWhere(
                (category) => category.name == taskMap['category'],
                orElse: () => Category.none,
              ),
            ))
        .toList();

    notifyListeners();
  }

  /// The list of user-created task categories.
  List<Category> _categories = [];

  /// Returns only the list of categories that have been created by the user.
  UnmodifiableListView<Category> get userCategories =>
      UnmodifiableListView(_categories);

  /// Returns the list of categories, with the default categories added. This is
  /// used for sorting tasks by category.
  UnmodifiableListView<Category> get sortCategories =>
      UnmodifiableListView([Category.all, ..._categories]);

  /// Returns the list of categories that the user can set for a task.
  UnmodifiableListView<Category> get setCategories =>
      UnmodifiableListView([Category.none, ..._categories]);

  /// Returns the number of categories stored.
  int get numCategories => _categories.length;

  /// Add a category to the list of categories if it is not already in the list.
  void addCategory(Category category) {
    if (!_categories.contains(category)) {
      _categories.add(category);
      // Update the database.
      _database.insert(
        'categories',
        category.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      notifyListeners();
    }
  }

  /// Remove a category from the list of categories if it is in the list.
  void removeCategory(Category category) {
    if (_categories.contains(category)) {
      _categories.remove(category);
      // Update the database.
      _database.delete(
        'categories',
        where: 'name = ?',
        whereArgs: [category.name],
      );
      notifyListeners();
    }
  }

  /// Modify a category in the list of categories by removing the old category
  /// and adding the new category.
  void modifyCategory(int categoryIndex, Category newCategory) {
    removeCategory(_categories[categoryIndex]);
    addCategory(newCategory);
  }

  /// The list of user-created tasks.
  List<Task> _tasks = [];

  /// Returns the list of tasks that can't be changed, because that would
  /// violate state.
  UnmodifiableListView<Task> get tasks => UnmodifiableListView(_tasks);

  /// Returns the number of tasks stored.
  int get numTasks => _tasks.length;

  /// Add a task to the list of tasks if it is not already in the list.
  void addTask(Task task) {
    if (!_tasks.contains(task)) {
      _tasks.add(task);
      // Update the database.
      _database.insert(
        'tasks',
        task.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      notifyListeners();
    }
  }

  /// Remove a task from the list of tasks.
  void removeTask(int taskIndex) {
    if (taskIndex < _tasks.length) {
      // Update the database.
      _database.delete(
        'tasks',
        where: 'id = ?',
        whereArgs: [_tasks[taskIndex].hashCode],
      );
      // Remove the task from the list.
      _tasks.removeAt(taskIndex);
      notifyListeners();
    } else {
      throw Exception('Task index out of bounds.');
    }
  }

  /// Modify a task in the list of tasks, by removing the old task and adding
  /// the new task.
  void modifyTask(int taskIndex, Task newTask) {
    removeTask(taskIndex);
    addTask(newTask);
  }

  /// Toggle if a task has been completed.
  void toggleTaskCompleted(int taskIndex) {
    if (taskIndex < _tasks.length) {
      _tasks[taskIndex].toggleCompleted();
      // Update the database.
      _database.update(
        'tasks',
        _tasks[taskIndex].toMap(),
        where: 'id = ?',
        whereArgs: [taskIndex],
      );
      notifyListeners();
    } else {
      throw Exception('Task index out of bounds.');
    }
  }

  /// Mark a task as complete.
  void markTaskComplete(int taskIndex) {
    if (taskIndex < _tasks.length) {
      _tasks[taskIndex].markComplete();
      // Update the database.
      _database.update(
        'tasks',
        _tasks[taskIndex].toMap(),
        where: 'id = ?',
        whereArgs: [taskIndex],
      );
      notifyListeners();
    } else {
      throw Exception('Task index out of bounds.');
    }
  }

  /// Mark a task as incomplete.
  void markTaskIncomplete(int taskIndex) {
    if (taskIndex < _tasks.length) {
      _tasks[taskIndex].markIncomplete();
      // Update the database.
      _database.update(
        'tasks',
        _tasks[taskIndex].toMap(),
        where: 'id = ?',
        whereArgs: [taskIndex],
      );
      notifyListeners();
    } else {
      throw Exception('Task index out of bounds.');
    }
  }
}
