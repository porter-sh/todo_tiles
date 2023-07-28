/// This file contains a widget that displays a task as a tile. It is
/// responsible for handling all the interactions with the task, such as
/// marking it as completed, editing it, and deleting it.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../task_data.dart';
import '../../types/task.dart';
import './task_tile_info_dialog.dart';

/// Public class [TaskTile] is a [StatelessWidget] that displays a task as a
/// tile. It is responsible for handling all the interactions with the task,
/// such as marking it as completed, editing it, and deleting it.
class TaskTile extends StatelessWidget {
  /// Creates a [TaskTile] widget.
  const TaskTile({
    super.key,
    required this.taskIndex,
  });

  /// The index of the task to display.
  final int taskIndex;

  /// Returns the widget that displays the task as a tile.
  @override
  Widget build(BuildContext context) {
    TaskData taskData = context.watch<TaskData>();
    final Task task = taskData.tasks[taskIndex];

    ButtonStyle notCompletedStyle = ElevatedButton.styleFrom(
      foregroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
      backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
      padding: const EdgeInsets.all(5),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      elevation: 3,
      splashFactory: NoSplash.splashFactory,
    );
    ButtonStyle isCompletedStyle = notCompletedStyle.copyWith(
      elevation: MaterialStateProperty.all(0),
    );

    return ElevatedButton(
      style: task.isCompleted ? isCompletedStyle : notCompletedStyle,
      onPressed: () {
        taskData.toggleTaskCompleted(taskIndex);
      },
      onLongPress: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) =>
            TaskTileInfoDialog(taskIndex: taskIndex),
      ),
      child: Column(
        children: [
          Text(task.name),
          Text(task.creationDate.toString()),
        ],
      ),
    );
  }
}
