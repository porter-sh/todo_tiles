/// This file contains the [Dialog] that is displayed when the user wants to
/// view more information about a task.

import 'package:flutter/material.dart';
import 'package:todo_tiles/util/icon_text.dart';

import '../types/task.dart';

/// Public class [TaskTileInfoDialog] is a [StatelessWidget] that displays a
/// [Dialog] with more information about a task.
class TaskTileInfoDialog extends StatelessWidget {
  /// Creates a [TaskTileInfoDialog] widget.
  const TaskTileInfoDialog({
    super.key,
    required this.task,
  });

  /// The task to display.
  final Task task;

  /// Returns the widget that displays the [Dialog] with more information about
  /// the task.
  @override
  Widget build(BuildContext context) {
    IconText countdownWidget = getCountdownWidget(context);

    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              task.name,
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
                        text: Text(task.category?.name ?? 'No category.'),
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
            Text('Created: ${task.creationDate.toString()}'),
          ],
        ),
      ),
    );
  }

  /// Returns a widget that displays a countdown if the task is due. Otherwise,
  /// returns a widget that displays that the task is either already completed,
  /// or has no due date.
  IconText getCountdownWidget(BuildContext context) {
    if (task.isCompleted) {
      return IconText(
        icon: const Icon(Icons.task_alt),
        text: Text(
            'Completed: ${task.completionDate.toString().substring(5, 16)}'),
      );
    }

    if (task.completionDate != null) {
      Duration timeLeft = task.completionDate!.difference(DateTime.now());
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

    return const IconText(
      icon: Icon(Icons.timer_off),
      text: Text('Not due.'),
    );
  }
}
