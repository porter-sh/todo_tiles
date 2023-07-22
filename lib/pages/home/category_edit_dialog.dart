/// This file contains the [CategoryEditDialog] widget, which is a fullscreen
/// dialog used for creating and editing categories.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../task_data.dart';
import '../../types/category.dart';

/// Public class [CategoryEditDialog] is a fullscreen dialog used for creating
/// and editing categories.
class CategoryEditDialog extends StatefulWidget {
  /// The index of the category being edited. A new category is created if null.
  final int? categoryIndex;

  /// Creates a new [CategoryEditDialog] with the given [categoryIndex].
  const CategoryEditDialog({Key? key, this.categoryIndex}) : super(key: key);

  /// Returns the state of the [CategoryEditDialog].
  @override
  State<CategoryEditDialog> createState() => _CategoryEditDialogState();
}

/// Private class [_CategoryEditDialogState] contains the state for the
/// [CategoryEditDialog].
class _CategoryEditDialogState extends State<CategoryEditDialog> {
  /// The name of the category.
  String? name;

  /// The description of the category.
  String? description;

  /// The form key for the form.
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// Returns the widget that displays the [CategoryEditDialog].
  @override
  Widget build(BuildContext context) {
    TaskData taskData = context.watch<TaskData>();

    // Update the text fields with the current values of the category.
    if (widget.categoryIndex != null) {
      name ??= taskData.setCategories[widget.categoryIndex!].name;
      description ??= taskData.setCategories[widget.categoryIndex!].description;
    } else {
      // Default values for new Category.
      name ??= '';
    }

    return Scaffold(
      // Bar at the top with back arrow and check mark.
      appBar: AppBar(
        title: const Text('Edit Category'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              // Validate the form when the user submits it.
              if (_formKey.currentState!.validate()) {
                if (widget.categoryIndex == null) {
                  taskData.addCategory(
                    Category(
                      name: name!,
                      description: description,
                    ),
                  );
                } else {
                  taskData.modifyCategory(
                    widget.categoryIndex!,
                    Category(
                      name: name!,
                      description: description,
                    ),
                  );
                }
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      // The form for editing the category.
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Text field for the name of the category.
            TextFormField(
              initialValue: name,
              decoration: const InputDecoration(
                labelText: 'Name',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name for the category.';
                }
                return null;
              },
              onChanged: (value) {
                name = value;
              },
            ),
            const SizedBox(height: 16.0),
            // Text field for the description of the category.
            TextFormField(
              initialValue: description,
              decoration: const InputDecoration(
                labelText: 'Description',
              ),
              onChanged: (value) {
                description = value;
              },
            ),
          ],
        ),
      ),
    );
  }
}
