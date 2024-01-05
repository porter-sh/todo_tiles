/// This file contains the definition of the [Category] type.

import 'dropdown_menu_item.dart';

/// Public class [Category] simply represents a category created by the user.
/// It exists to make it easier to add new features in the future.
class Category implements FilterMenuItem<Category> {
  /// The id of the category.
  int? id;

  /// The name of the category.
  String? name;

  /// The discription of the category.
  String? description;

  /// The color of the category.
  String? color;

  /// Constructor for the [Category] class.
  Category({
    this.id,
    this.name,
    this.description,
    this.color,
  });

  /// Copy constructor for the [Category] class.
  Category.from(Category? category) {
    if (category == null) {
      return;
    }

    id = category.id;
    name = category.name;
    description = category.description;
    color = category.color;
  }

  /// Category that represents all categories.
  static final all =
      Category(id: -2, name: 'All', description: 'All categories');

  /// Category that represents no categories.
  static final none =
      Category(id: -1, name: 'None', description: 'No category');

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
        'display_color': color,
      };

  /// Used for showing the category in a dropdown menu.
  @override
  String get value => name ?? '';
}
