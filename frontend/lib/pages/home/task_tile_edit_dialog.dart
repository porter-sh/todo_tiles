/// This file contains the [TaskTileEditDialog] widget, which is a dialog that
/// allows the user to edit a task.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../task_data.dart';
import '../../types/category.dart';
import '../../types/task.dart';

/// Public class [TaskTileEditDialog] is a [StatefulWidget] that displays a
/// fullscreen dialog that allows the user to edit a task.
class TaskTileEditDialog extends StatefulWidget {
  /// Creates a [TaskTileEditDialog] widget.
  const TaskTileEditDialog({
    super.key,
    this.taskId,
  });

  /// The id of the task to edit. Null if the task is new.
  final int? taskId;

  /// Returns the state of the [TaskTileEditDialog] widget.
  @override
  State<TaskTileEditDialog> createState() => _TaskTileEditDialogState();
}

/// Private class [_TaskTileEditDialogState] is the state of the
/// [TaskTileEditDialog] widget.
class _TaskTileEditDialogState extends State<TaskTileEditDialog> {
  /// The new task.
  Task task = Task();

  /// The form key for the form.
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// Returns the widget that displays the [TaskTileEditDialog].
  @override
  Widget build(BuildContext context) {
    TaskData taskData = context.watch<TaskData>();

    // Update the text fields with the current values of the task.
    if (widget.taskId != null) {
      task = taskData.getTaskById(widget.taskId!);
    } else {
      // Default values for new Task.
      task.name ??= '';
    }

    // Text controller for updating the date with the date picker.
    TextEditingController dateController = TextEditingController(
      text: task.dueDate?.toString().substring(0, 16),
    );

    return Scaffold(
      // Bar at the top with back arrow and check mark.
      appBar: AppBar(
        title: const Text('Edit Task'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              // Validate the form when the user submits it.
              if (_formKey.currentState!.validate()) {
                if (widget.taskId == null) {
                  taskData.addTask(task);
                } else {
                  taskData.commitTask(task);
                }
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              initialValue: task.name,
              decoration: const InputDecoration(
                labelText: 'Name',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name.';
                }
                return null;
              },
              onChanged: (String? value) {
                task.name = value;
              },
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              initialValue: task.description,
              decoration: const InputDecoration(
                labelText: 'Description',
              ),
              onChanged: (String? value) {
                task.description = value;
              },
            ),
            const SizedBox(height: 16.0),
            DropdownButtonFormField<Category>(
              value: task.category,
              decoration: const InputDecoration(
                labelText: 'Category',
              ),
              items: taskData.setCategories
                  .map(
                    (Category category) => DropdownMenuItem<Category>(
                      value: category,
                      child: Text(category.name ?? ''),
                    ),
                  )
                  .toList(),
              onChanged: (Category? value) {
                task.category = value;
              },
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: dateController,
              decoration: InputDecoration(
                labelText: 'Due Date',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_month),
                  // When the calendar button is pressed, open up a date picker.
                  onPressed: () => showDatePicker(
                    context: context,
                    initialDate: task.dueDate ?? DateTime.now(),
                    // Allow the user to set any past date.
                    firstDate: DateTime.utc(-271821, 05, 20),
                    // Allow the user to set any future date.
                    lastDate: DateTime.utc(275760, 09, 12),
                  ).then((DateTime? value) {
                    if (value != null) {
                      // Ensure the new date does not overwrite the time.
                      DateTime combined = DateTime(
                        value.year,
                        value.month,
                        value.day,
                        task.dueDate?.hour ?? 0,
                        task.dueDate?.minute ?? 0,
                        task.dueDate?.second ?? 0,
                        task.dueDate?.millisecond ?? 0,
                        task.dueDate?.microsecond ?? 0,
                      );

                      // Update the text field with the new date.
                      dateController.text =
                          combined.toString().substring(0, 16);
                      // Update the value of the due date.
                      task.dueDate = combined;

                      // If a valid date was selected, open up a time picker.
                      showTimePicker(
                        context: context,
                        initialTime: TimeOfDay(
                          hour: task.dueDate?.hour ?? 0,
                          minute: task.dueDate?.minute ?? 0,
                        ),
                      ).then((TimeOfDay? value) {
                        if (value != null) {
                          // Ensure the new time does not overwrite the date.
                          DateTime combined = DateTime(
                            task.dueDate?.year ?? DateTime.now().year,
                            task.dueDate?.month ?? DateTime.now().month,
                            task.dueDate?.day ?? DateTime.now().day,
                            value.hour,
                            value.minute,
                          );

                          // Update the text field with the new date.
                          dateController.text =
                              combined.toString().substring(0, 16);
                          // Update the value of the due date.
                          task.dueDate = combined;
                        }
                      });
                    }
                  }),
                ),
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) return null;
                try {
                  task.dueDate = DateTime.parse(value);
                } catch (e) {
                  return 'Please enter a valid date.';
                }
                return null;
              },
              // Do not try to force the dueDate to be a valie date, because it
              // will throw an error while the user is typing.
              onChanged: (value) {
                try {
                  task.dueDate = DateTime.parse(value);
                } catch (e) {
                  task.dueDate = null;
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
