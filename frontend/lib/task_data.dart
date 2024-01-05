/// This file contains the class that stores the data for the app. Eventually,
/// this should be responsible for interacting with a database, but for now, it
/// just stores the data in memory.

import 'dart:collection';

import 'package:flutter/material.dart';

import 'types/category.dart';
import 'types/completion_filter.dart';
import 'types/task.dart';
import 'types/time_horizon.dart';
import 'util/api.dart';

/// Public class [TaskData] is a [ChangeNotifier] that stores the data for the
/// app.
class TaskData with ChangeNotifier {
  /// Update the data at the beginning to reflect the database.
  TaskData() {
    syncTasksFromBackend();
    syncCategoriesFromBackend();
  }

  /// The category for the current view.
  Category? _categoryFilter;

  /// The completion filter for the current view.
  CompletionFilter? _completionFilter;

  /// The time horizon for the current view.
  TimeHorizon? _timeHorizonFilter;

  /// Map of user-created task categories.
  Map<int, Category> _categories = {
    Category.all.id!: Category.all,
    Category.none.id!: Category.none
  };

  /// List of the user-created categories.
  List<Category> get categories => _categories.values.toList();

  /// The list of categories that can be used to set tasks.
  List<Category> get setCategories {
    List<Category> setCategories = List.from(_categories.values);
    setCategories.remove(Category.all);
    return setCategories;
  }

  /// Returns the number of categories stored.
  int get numCategories => _categories.length;

  /// Update the list of categories to reflect the database.
  void syncCategoriesFromBackend() async {
    _categories = await API.get(path: 'categories').then((response) {
      try {
        response = response as List<dynamic>;
      } catch (e) {
        // Malformed response.
        response = [];
      }
      // Convert the response to a map of categories.
      Map<int, Category> categories = {};
      for (var categoryMap in response) {
        Category category = Category.fromJson(categoryMap);
        categories[category.id!] = category;
      }
      return categories;
    });

    _categories[Category.all.id!] = Category.all;
    _categories[Category.none.id!] = Category.none;

    notifyListeners();
  }

  /// Get the category by its id.
  Category? getCategoryById(int id) => _categories[id];

  /// Add a category to the list of categories if it is not already in the list.
  /// This needs to sync with the backend to ensure the category has a valid id.
  void addCategory(Category category) async {
    // Send the new category to the database.
    await API.post(
      path: 'categories',
      body: category.toJson(),
    );

    syncCategoriesFromBackend();
    notifyListeners();
  }

  /// Remove a category from the local list of categories, and on the backend.
  void removeCategory(int categoryId) {
    if (_categories[categoryId] == null) {
      return;
    }

    _categories.remove(categoryId);

    // Send the category to the database.
    API.delete(path: 'categories/$categoryId');

    notifyListeners();
  }

  /// Update a category in the database. To be used when a category has already
  /// been modified locally. Assumes a category with the same id is already in
  /// the list.
  void updateCategory(int categoryId) {
    if (_categories[categoryId] == null) {
      return;
    }

    // Send the updated category to the database.
    API.put(
      path: 'categories/$categoryId',
      body: _categories[categoryId]!.toJson(),
    );

    notifyListeners();
  }

  /// Update a category in the database given a Category. Assumes a category
  /// with the same id is already in the list.
  void commitCategory(Category category) {
    _categories[category.id!] = category;
    updateCategory(category.id!);
  }

  /// The ids of the current tasks, mapped to their task.
  Map<int, Task> _tasks = {};

  /// Get the number of currently displayed tasks.
  int get numTasks => _tasks.length;

  /// Update the list of tasks to reflect the database.
  void syncTasksFromBackend() async {
    _tasks = await API.get(path: 'tasks', queryParameters: {
      'categoryId': _categoryFilter?.name ?? '',
      'filter': _completionFilter?.string ?? '',
      'timeHorizon': _timeHorizonFilter?.string.toLowerCase() ?? '',
    }).then((response) {
      try {
        response = response as List<dynamic>;
      } catch (e) {
        // Malformed response.
        response = [];
      }
      // Convert the response to a map of tasks.
      Map<int, Task> tasks = {};
      for (var taskMap in response) {
        Task task = Task.fromJson(taskMap);
        tasks[task.id!] = task;
      }
      return tasks;
    });

    notifyListeners();
  }

  Task getTaskById(int id) => _tasks[id]!;

  /// Get the id of a task by its index in the list of tasks.
  int getTaskIdByIndex(int index) => _tasks.keys.elementAt(index);

  /// Add a task to the list of tasks if it is not already in the list. This
  /// needs to sync with the backend to ensure the task has a valid id.
  void addTask(Task task) async {
    // Send the new task to the database.
    await API.post(
      path: 'tasks',
      body: task.toJson(),
    );

    syncTasksFromBackend();
    notifyListeners();
  }

  /// Remove a task from the local list of tasks, and on the backend.
  void removeTask(int taskId) {
    if (_tasks[taskId] == null) {
      return;
    }

    _tasks.remove(taskId);

    // Send the task to the database.
    API.delete(path: 'tasks/$taskId');

    notifyListeners();
  }

  /// Update a task in the database. To be used when a task has already been
  /// modified locally. Assumes a task with the same id is already in the list.
  void updateTask(int taskId) {
    if (_tasks[taskId] == null) {
      return;
    }

    // Send the updated task to the database.
    API.put(
      path: 'tasks/$taskId',
      body: _tasks[taskId]!.toJson(),
    );

    notifyListeners();
  }

  /// Update a task in the database given a Task. Assumes a task with the same
  /// id is already in the list.
  void commitTask(Task task) {
    _tasks[task.id!] = task;
    updateTask(task.id!);
  }

  /// Set task completion locally and on the backend.
  void completeTask(int? taskId, {bool isCompleted = true}) {
    if (taskId == null || _tasks[taskId] == null) {
      return;
    }

    _tasks[taskId]!.completionDate = isCompleted ? DateTime.now() : null;

    // Send the update to the database.
    API.put(path: 'tasks/$taskId/completed', body: {'completed': isCompleted});

    notifyListeners();
  }

  /// Toggle whether a task is completed.
  void toggleTaskCompleted(int taskId) {
    completeTask(taskId, isCompleted: !_tasks[taskId]!.isCompleted);
  }
}
