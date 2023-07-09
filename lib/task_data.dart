/// This file contains the class that stores the data for the app. Eventually,
/// this should be responsible for interacting with a database, but for now, it
/// just stores the data in memory.

import 'package:flutter/material.dart';

import 'types/category.dart';
import 'types/task.dart';

/// Public class [TaskData] is a [ChangeNotifier] that stores the data for the
/// app.
class TaskData with ChangeNotifier {
  /// The list of user-created task categories.
  final List<Category> _categories = [];

  /// Returns the list of categories.
  List<Category> get categories => _categories;

  /// Returns the number of categories stored.
  int get numCategories => _categories.length;

  /// Add a category to the list of categories if it is not already in the list.
  void addCategory(Category category) {
    if (!_categories.contains(category)) {
      _categories.add(category);
      notifyListeners();
    }
  }

  /// Remove a category from the list of categories if it is in the list.
  void removeCategory(Category category) {
    if (_categories.contains(category)) {
      _categories.remove(category);
      notifyListeners();
    }
  }

  /// The list of user-created tasks.
  final List<Task> _tasks = [];

  /// Returns the list of tasks.
  List<Task> get tasks => _tasks;

  /// Returns the number of tasks stored.
  int get numTasks => _tasks.length;

  /// Add a task to the list of tasks if it is not already in the list.
  void addTask(Task task) {
    if (!_tasks.contains(task)) {
      _tasks.add(task);
      notifyListeners();
    }
  }

  /// Remove a task from the list of tasks if it is in the list.
  void removeTask(Task task) {
    if (_tasks.contains(task)) {
      _tasks.remove(task);
      notifyListeners();
    }
  }
}
