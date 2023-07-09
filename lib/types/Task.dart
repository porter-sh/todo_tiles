import 'Category.dart';

/// This file contains the definition of the Task type.

/// Public class [Task] represents a task created by the user. It exists to make
/// it easier to add new features in the future.
class Task {
  /// The name of the task.
  final String name;

  /// Description of the task.
  final String? description;

  /// The category of the task.
  final Category? category;

  /// Creates a new [Task] with the given [name], [category], and [dueDate].
  const Task({
    required this.name,
    this.description,
    this.category,
  });
}
