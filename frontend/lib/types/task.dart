import 'category.dart';

/// Public class [Task] represents a task created by the user. Different from
/// BackendTask in that it can be modified, and generally should not be used to
/// communicate with the backend.
class Task {
  /// The id of the task.
  int? id;

  /// The category of the task.
  Category? category;

  /// The name of the task.
  String? name;

  /// Description of the task.
  String? description;

  /// When the task was created.
  DateTime? creationDate;

  /// The due date of the task.
  DateTime? dueDate;

  /// When the task was completed.
  DateTime? completionDate;

  /// Whether the task is completed or not.
  bool get isCompleted => completionDate != null;

  /// Whether the task has a due date or not.
  bool get hasDueDate => dueDate != null;

  /// Constructor for the [Task] class.
  Task({
    this.id,
    this.category,
    this.name,
    this.description,
    this.creationDate,
    this.dueDate,
    this.completionDate,
  });
}
