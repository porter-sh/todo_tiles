/// This file contains the class that stores the data for the app. Eventually,
/// this should be responsible for interacting with a database, but for now, it
/// just stores the data in memory.

import 'dart:collection';

import 'package:flutter/material.dart';

import 'types/category.dart';
import 'types/backend_task.dart';
import 'types/completion_filter.dart';
import 'types/time_horizon.dart';
import 'util/api.dart';

/// Public class [TaskData] is a [ChangeNotifier] that stores the data for the
/// app.
class TaskData with ChangeNotifier {
  /// Update the data at the beginning to reflect the database.
  TaskData() {
    syncTasksFromBackend();
  }

  /// The category for the current view.
  Category? _categoryFilter;

  /// The completion filter for the current view.
  CompletionFilter? _completionFilter;

  /// The time horizon for the current view.
  TimeHorizon? _timeHorizonFilter;

  /// The list of user-created task categories.
  final List<Category> _categories = [];

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

  /// Modify a category in the list of categories by removing the old category
  /// and adding the new category.
  void modifyCategory(int categoryIndex, Category newCategory) {
    removeCategory(_categories[categoryIndex]);
    addCategory(newCategory);
  }

  /// The ids of the current tasks, mapped to their task.
  Map<int, BackendTask> _tasks = {};

  /// Get the number of currently displayed tasks.
  int get numTasks => _tasks.length;

  /// Update the list of tasks to reflect the database.
  void syncTasksFromBackend() async {
    // Clear the list of tasks.
    _tasks = {};

    _tasks = await API.get(path: 'tasks', queryParameters: {
      'categoryId': _categoryFilter?.backendRepresentation,
      'filter': _completionFilter?.backendRepresentation,
      'timeHorizon': _timeHorizonFilter?.backendRepresentation,
    }).then((response) {
      try {
        response = response as List<dynamic>;
      } catch (e) {
        // Malformed response.
        response = [];
      }
      // Convert the response to a map of tasks.
      Map<int, BackendTask> tasks = {};
      for (var taskMap in response) {
        BackendTask task = BackendTask.fromJson(taskMap);
        tasks[task.id!] = task;
      }
      return tasks;
    });

    notifyListeners();
  }

  BackendTask getTaskById(int id) => _tasks[id]!;

  /// Get the id of a task by its index in the list of tasks.
  int getTaskIdByIndex(int index) => _tasks.keys.elementAt(index);

  /// Add a task to the list of tasks if it is not already in the list.
  void addTask(BackendTask task) async {
    // Send the new task to the database.
    API.post(
      path: 'tasks',
      body: task.toJson(),
    );

    syncTasksFromBackend();
    notifyListeners();
  }

  /// Remove a task from the database.
  void removeTask(BackendTask task) {
    // Send the task to the database.
    API.delete(path: 'tasks/${task.id}');

    syncTasksFromBackend();
    notifyListeners();
  }

  /// Modify a task in the list of tasks on the backend, then update the list of
  /// tasks to reflect the database.
  void modifyTask(BackendTask newTask) {
    // Send the new task to the database.
    API.put(
      path: 'tasks/${newTask.id}',
      body: newTask.toJson(),
    );

    syncTasksFromBackend();
    notifyListeners();
  }

  /// Set a task to completed on the backend, then update the list of tasks.
  void completeTask(BackendTask task) {
    // Send the task to the database.
    API.put(
      path: 'tasks/${task.id}/complete',
      body: task.toJson(),
    );

    syncTasksFromBackend();
    notifyListeners();
  }

  /// Set a task to incomplete on the backend, then update the list of tasks.
  void uncompleteTask(BackendTask task) {
    // Send the task to the database.
    API.put(
      path: 'tasks/${task.id}/uncomplete',
      body: task.toJson(),
    );

    syncTasksFromBackend();
    notifyListeners();
  }

  /// Toggle whether a task is completed.
  void toggleTaskCompleted(int taskId) {
    BackendTask task = getTaskById(taskId);
    if (task.isCompleted) {
      uncompleteTask(task);
    } else {
      completeTask(task);
    }
  }
}
