/// This file contains the definition of the BackendTask type, which is used as
/// to communicate tasks with the backend.

import 'category.dart';
import 'task.dart';

/// Public class [BackendTask] represents a task going directly from or to the
/// backend. It is different from [Task] in that it is not meant to be modified.
class BackendTask {
  final Task _task;

  /// Getters for the underlying data.
  Task get task => _task;
  int? get id => _task.id;
  Category? get category => _task.category;
  String? get name => _task.name;
  String? get description => _task.description;
  DateTime? get creationDate => _task.creationDate;
  DateTime? get dueDate => _task.dueDate;
  DateTime? get completionDate => _task.completionDate;
  bool get isCompleted => _task.isCompleted;
  bool get hasDueDate => _task.hasDueDate;

  /// Constructor for the [BackendTask] class.
  BackendTask({
    required Task task,
  }) : _task = task;

  /// Constructor for the [BackendTask] class from a JSON object.
  factory BackendTask.fromJson(Map<String, dynamic> json) => BackendTask(
        task: Task(
          id: json['id'],
          category: Category.fromJson(json['category_id']),
          name: json['name'],
          description: json['description'],
          creationDate: DateTime.tryParse(json['creation_date']),
          dueDate: json['due_date'] == null
              ? null
              : DateTime.tryParse(json['due_date']),
          completionDate: json['completion_date'] == null
              ? null
              : DateTime.tryParse(json['completion_date']),
        ),
      );

  /// Converts the [BackendTask] object to a JSON object.
  Map<String, dynamic> toJson() => {
        'id': _task.id,
        'category': _task.category?.toJson(),
        'name': _task.name,
        'description': _task.description,
        'creation_date': _task.creationDate?.toIso8601String(),
        'due_date': _task.dueDate?.toIso8601String(),
        'completion_date': _task.completionDate?.toIso8601String(),
      };
}
