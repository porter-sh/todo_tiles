import 'category.dart';

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

  /// The due date of the task.
  final DateTime? dueDate;

  /// When the task was created.
  DateTime creationDate = DateTime.now();

  /// Creates a new [Task] with the given [name], [category], and [dueDate].
  Task({
    required this.name,
    this.description,
    this.category,
    this.dueDate,
  });

  /// Overrides the equality operator so that two tasks are equal if they have
  /// the same unique identifier. This way, even tasks with all the same details
  /// are consedered to be different tasks.
  @override
  bool operator ==(Object other) {
    if (other is Task) {
      return hashCode == other.hashCode;
    } else {
      return false;
    }
  }

  /// Overrides the hashcode getter so that no two tasks would reasonably have
  /// the same hashcode.
  @override
  int get hashCode => (name + creationDate.toString()).hashCode;
}
