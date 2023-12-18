/// This file contains the [Dialog] that is displayed when the user wants to
/// view more information about a task.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/icon_text.dart';
import '../../task_data.dart';
import '../../types/category.dart';
import '../../types/task.dart';
import 'task_tile_edit_dialog.dart';

/// Public class [TaskTileInfoDialog] is a [StatelessWidget] that displays a
/// [Dialog] with more information about a task.
class TaskTileInfoDialog extends StatelessWidget {
  /// Creates a [TaskTileInfoDialog] widget.
  const TaskTileInfoDialog({
    super.key,
    required this.taskId,
  });

  /// The task to display.
  final int taskId;

  /// Returns the widget that displays the [Dialog] with more information about
  /// the task.
  @override
  Widget build(BuildContext context) {
    TaskData taskData = context.watch<TaskData>();
    Task task = taskData.getTaskById(taskId);
    IconText countdownWidget = getCountdownWidget(context, task);

    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              task.name ?? 'Unnamed task',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            if (task.description != null) Text(task.description!),
            const Divider(),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconText(
                        icon: const Icon(Icons.category),
                        text: Text(task.category?.name ?? Category.none.name),
                      ),
                      IconText(
                        icon: const Icon(Icons.today),
                        text:
                            Text(task.creationDate.toString().substring(5, 16)),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const IconText(
                        icon: Icon(Icons.show_chart),
                        text: Text('No series.'),
                      ),
                      IconText(
                        icon: const Icon(Icons.event),
                        text: Text(task.dueDate?.toString().substring(5, 16) ??
                            'No due date.'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            countdownWidget,
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    color: Colors.red,
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      Navigator.pop(context);
                      // wait for the dialog to close before removing the task
                      Future.delayed(const Duration(milliseconds: 150), () {
                        taskData.removeTask(task.id);
                      });
                    }),
                IconButton(
                  color: Theme.of(context).colorScheme.primary,
                  icon: const Icon(Icons.edit),
                  onPressed: () => {
                    Navigator.pop(context),
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) =>
                          TaskTileEditDialog(taskId: taskId),
                    ),
                  },
                ),
                IconButton(
                  color: task.isCompleted ? Colors.grey : Colors.green,
                  icon: const Icon(Icons.check),
                  onPressed: () => taskData.completeTask(task.id,
                      isCompleted: !task.isCompleted),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  /// Returns a widget that displays a countdown if the task is due. Otherwise,
  /// returns a widget that displays that the task is either already completed,
  /// or has no due date.
  IconText getCountdownWidget(BuildContext context, Task task) {
    if (task.isCompleted) {
      return IconText(
        icon: const Icon(Icons.task_alt),
        text: Text(
            'Completed: ${task.completionDate.toString().substring(5, 16)}'),
      );
    }
    task.name = 'test';

    if (!task.hasDueDate) {
      return const IconText(
        icon: Icon(Icons.timer_off),
        text: Text('Not due.'),
      );
    }

    Duration timeLeft = task.dueDate!.difference(DateTime.now());
    Text timeLeftText;
    // Create a different message based on when the task is due.
    if (timeLeft.inDays > 0) {
      timeLeftText = Text('${timeLeft.inDays} days left.');
    } else if (timeLeft.inHours > 0) {
      timeLeftText = Text(
        '${timeLeft.inHours} hours left.',
        style: TextStyle(color: Theme.of(context).colorScheme.error),
      );
    } else {
      timeLeftText = Text(
        '${timeLeft.inMinutes} minutes left.',
        style: TextStyle(color: Theme.of(context).colorScheme.error),
      );
    }

    return IconText(
      icon: const Icon(Icons.timer),
      text: timeLeftText,
    );
  }
}
