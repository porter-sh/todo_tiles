/// TODO
/// tile widget
///
/// on tap, mark completed
/// on long press, open alert dialog to edit
/// when typing, move to ensure visibility

/// This file contains a widget that displays a task as a tile. It is
/// responsible for handling all the interactions with the task, such as
/// marking it as completed, editing it, and deleting it.

import 'package:flutter/material.dart';

import '../types/task.dart';

/// Public class [TaskTile] is a [StatelessWidget] that displays a task as a
/// tile. It is responsible for handling all the interactions with the task,
/// such as marking it as completed, editing it, and deleting it.
class TaskTile extends StatelessWidget {
  /// Creates a [TaskTile] widget.
  const TaskTile({
    super.key,
    required this.task,
  });

  /// The task to display.
  final Task task;

  /// Returns the widget that displays the task as a tile.
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Text(task.name),
          Text(task.creationDate.toString()),
        ],
      ),
    );
  }
}
