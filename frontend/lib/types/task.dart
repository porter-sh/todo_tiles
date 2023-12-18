import 'category.dart';

/// Public class [Task] represents a task created by the user.
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

  /// Constructor for the [Task] class from a JSON object.
  factory Task.fromJson(Map<String, dynamic> json) => Task(
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
      );

  /// Converts the [Task] object to a JSON object.
  Map<String, dynamic> toJson() => {
        'id': id,
        'category': category?.toJson(),
        'name': name,
        'description': description,
        'creation_date': creationDate?.toIso8601String(),
        'due_date': dueDate?.toIso8601String(),
        'completion_date': completionDate?.toIso8601String(),
      };
}
