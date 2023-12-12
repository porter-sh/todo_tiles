/// This file contains the definition of the [Category] type.

import 'backend_translator.dart';
import 'dropdown_menu_item.dart';

/// Public class [Category] simply represents a category created by the user.
/// It exists to make it easier to add new features in the future.
class Category
    implements FilterMenuItem<Category>, BackendTranslator<Category> {
  /// The id of the category.
  final int? id;

  /// The name of the category.
  final String name;

  /// The discription of the category.
  final String? description;

  /// The color of the category.
  final String? color;

  /// Constructor for the [Category] class.
  Category({
    this.id,
    required this.name,
    this.description,
    this.color,
  });

  /// Category that represents all categories.
  static final all = Category(name: 'All', description: 'All categories');

  /// Category that represents no categories.
  static final none = Category(name: 'None', description: 'No category');

  /// Constructor for the [Category] class from a JSON object.
  factory Category.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return none;
    }
    return Category(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      color: json['color'],
    );
  }

  /// Converts the [Category] object to a JSON object.
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'color': color,
      };

  /// Used for showing the category in a dropdown menu.
  @override
  String get value => name;

  @override
  String get backendRepresentation => name;
}
