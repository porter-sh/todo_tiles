/// This file contains the [CategoryEditDialog] widget, which is a fullscreen
/// dialog used for creating and editing categories.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../task_data.dart';
import '../../types/category.dart';

/// Public class [CategoryEditDialog] is a fullscreen dialog used for creating
/// and editing categories.
class CategoryEditDialog extends StatefulWidget {
  /// The id of the category being edited. A new category is created if null.
  final int? categoryId;

  /// Creates a new [CategoryEditDialog] with the given [categoryIndex].
  const CategoryEditDialog({Key? key, this.categoryId}) : super(key: key);

  /// Returns the state of the [CategoryEditDialog].
  @override
  State<CategoryEditDialog> createState() => _CategoryEditDialogState();
}

/// Private class [_CategoryEditDialogState] contains the state for the
/// [CategoryEditDialog].
class _CategoryEditDialogState extends State<CategoryEditDialog> {
  /// The new category.
  Category category = Category();

  /// The form key for the form.
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// Returns the widget that displays the [CategoryEditDialog].
  @override
  Widget build(BuildContext context) {
    TaskData taskData = context.watch<TaskData>();

    // Update the text fields with the current values of the category.
    if (widget.categoryId != null &&
        taskData.getCategoryById(widget.categoryId!) != null) {
      category = Category.from(taskData.getCategoryById(widget.categoryId!));
    } else {
      // Default values for new Category.
      category.name ??= '';
    }

    return Scaffold(
      // Bar at the top with back arrow and check mark.
      appBar: AppBar(
        title: const Text('Edit Category'),
        actions: [
          // Button to delete the category if it is not a new category.
          if (widget.categoryId != null && widget.categoryId! >= 0)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                Navigator.pop(context);
                // Wait for the dialog to close before deleting the category.
                Future.delayed(const Duration(milliseconds: 150), () {
                  taskData.removeCategory(widget.categoryId!);
                });
              },
            ),
          // Button to save changes.
          if (widget.categoryId == null || widget.categoryId! >= 0)
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: () {
                // Validate the form when the user submits it.
                if (_formKey.currentState!.validate()) {
                  if (widget.categoryId == null) {
                    taskData.addCategory(category);
                  } else {
                    taskData.commitCategory(category);
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
              initialValue: category.name,
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
                category.name = value;
              },
            ),
            const SizedBox(height: 16.0),
            // Text field for the description of the category.
            TextFormField(
              initialValue: category.description,
              decoration: const InputDecoration(
                labelText: 'Description',
              ),
              onChanged: (value) {
                category.description = value;
              },
            ),
            const SizedBox(height: 16.0),
            // Dropdown menu for the color of the category.
            DropdownButtonFormField<String>(
              value: category.color,
              decoration: const InputDecoration(
                labelText: 'Color',
              ),
              items: [
                'red',
                'orange',
                'yellow',
                'green',
                'blue',
                'purple',
                'pink',
                'brown',
                'grey',
              ]
                  .map(
                    (String color) => DropdownMenuItem<String>(
                      value: color,
                      child: Text(color),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                category.color = value;
              },
            ),
          ],
        ),
      ),
    );
  }
}
