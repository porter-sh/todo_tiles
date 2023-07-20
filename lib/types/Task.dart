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

  /// When the task was completed.
  DateTime? completionDate;

  /// Completes the task if it isn't already.
  void markComplete() {
    if (!isCompleted) {
      completionDate = DateTime.now();
    }
  }

  /// Uncompletes the task if it is completed.
  void markIncomplete() {
    if (isCompleted) {
      completionDate = null;
    }
  }

  /// Toggles whether the task is completed.
  void toggleCompleted() {
    if (isCompleted) {
      markIncomplete();
    } else {
      markComplete();
    }
  }

  /// Whether the task is completed.
  bool get isCompleted => completionDate != null;

  /// Creates a new [Task] with the given [name], [category], and [dueDate].
  Task({
    required this.name,
    this.description,
    this.category,
    this.dueDate,
  });

  /// Creates a new [Task] from a map of values.
  Task.fromMap(Map<String, dynamic> map)
      : name = map['name'],
        description = map['description'],
        category = map['category'],
        dueDate =
            map['dueDate'] != 'NULL' ? DateTime.parse(map['dueDate']) : null,
        creationDate = DateTime.parse(map['creationDate']),
        completionDate = map['completionDate'] != 'NULL'
            ? DateTime.parse(map['completionDate'])
            : null;

  /// Converts the [Task] to a map of values.
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'category': category,
      'dueDate': dueDate?.toString() ?? 'NULL',
      'creationDate': creationDate.toString(),
      'completionDate': completionDate?.toString() ?? 'NULL',
    };
  }

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
  int get hashCode => (creationDate.toString()).hashCode;
}
