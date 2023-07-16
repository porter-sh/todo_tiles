/// This file contains the class that stores the data for the app. Eventually,
/// this should be responsible for interacting with a database, but for now, it
/// just stores the data in memory.

import 'dart:collection';

import 'package:flutter/material.dart';

import 'types/category.dart';
import 'types/task.dart';

/// Public class [TaskData] is a [ChangeNotifier] that stores the data for the
/// app.
class TaskData with ChangeNotifier {
  /// The list of user-created task categories.
  final List<Category> _categories = [];

  /// Returns the list of categories, with the default categories added.
  List<Category> get categories => [
        Category.all,
        Category.none,
        ..._categories,
      ];

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

  /// Returns the list of tasks that can't be changed, because that would
  /// violate state.
  UnmodifiableListView<Task> get tasks => UnmodifiableListView(_tasks);

  /// Returns the number of tasks stored.
  int get numTasks => _tasks.length;

  /// Add a task to the list of tasks if it is not already in the list.
  void addTask(Task task) {
    if (!_tasks.contains(task)) {
      _tasks.add(task);
      notifyListeners();
    }
  }

  /// Remove a task from the list of tasks.
  void removeTask(int taskIndex) {
    if (taskIndex < _tasks.length) {
      _tasks.removeAt(taskIndex);
      notifyListeners();
    } else {
      throw Exception('Task index out of bounds.');
    }
  }

  /// Toggle if a task has been completed.
  void toggleTaskCompleted(int taskIndex) {
    if (taskIndex < _tasks.length) {
      _tasks[taskIndex].toggleCompleted();
      notifyListeners();
    } else {
      throw Exception('Task index out of bounds.');
    }
  }

  /// Mark a task as complete.
  void markTaskComplete(int taskIndex) {
    if (taskIndex < _tasks.length) {
      _tasks[taskIndex].markComplete();
      notifyListeners();
    } else {
      throw Exception('Task index out of bounds.');
    }
  }

  /// Mark a task as incomplete.
  void markTaskIncomplete(int taskIndex) {
    if (taskIndex < _tasks.length) {
      _tasks[taskIndex].markIncomplete();
      notifyListeners();
    } else {
      throw Exception('Task index out of bounds.');
    }
  }
}
