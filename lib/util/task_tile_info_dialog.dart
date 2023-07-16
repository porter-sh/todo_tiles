/// This file contains the [Dialog] that is displayed when the user wants to
/// view more information about a task.

import 'package:flutter/material.dart';

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
    List<Widget> taskInfoColumnChildren = [
      Text(
        task.name,
        style: Theme.of(context).textTheme.headlineLarge,
      )
    ];

    if (task.description != null) {
      taskInfoColumnChildren.add(Text(task.description!));
    }

    taskInfoColumnChildren.addAll([
      const Divider(),
      Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.category),
                    const SizedBox(width: 5),
                    Text(task.category?.name ?? 'No category.'),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.today),
                    const SizedBox(width: 5),
                    Text(task.creationDate.toString().substring(5, 16)),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.show_chart),
                    SizedBox(width: 5),
                    Text('No series.'),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.event),
                    const SizedBox(width: 5),
                    Text(task.dueDate?.toString().substring(0, 10) ??
                        'No due date.'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ]);

    if (task.isCompleted) {
      taskInfoColumnChildren.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check),
            const SizedBox(width: 5),
            Text(
                'Completed: ${task.completionDate.toString().substring(0, 10)}'),
          ],
        ),
      );
    } else if (task.completionDate != null) {
      Duration timeLeft = task.completionDate!.difference(DateTime.now());
      taskInfoColumnChildren.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.timer),
            const SizedBox(width: 5),
            if (timeLeft.inDays > 0)
              Text('${timeLeft.inDays} days left.')
            else if (timeLeft.inHours > 0)
              Text(
                '${timeLeft.inHours} hours left.',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              )
            else
              Text(
                '${timeLeft.inMinutes} minutes left.',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
          ],
        ),
      );
    } else {
      taskInfoColumnChildren.add(
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.timer_off),
            SizedBox(width: 5),
            Text('Not due.'),
          ],
        ),
      );
    }

    taskInfoColumnChildren.addAll([
      const Divider(),
      Text('Created: ${task.creationDate.toString()}'),
    ]);

    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: taskInfoColumnChildren,
        ),
      ),
    );
  }
}
