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
class TaskTile extends StatefulWidget {
  /// Creates a [TaskTile] widget.
  const TaskTile({
    super.key,
    required this.task,
  });

  /// The task to display.
  final Task task;

  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  /// Returns the widget that displays the task as a tile.
  @override
  Widget build(BuildContext context) {
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
      style: widget.task.isCompleted ? isCompletedStyle : notCompletedStyle,
      onPressed: () {
        setState(() {
          widget.task.toggleCompleted();
        });
      },
      onLongPress: () {
        print('long pressed');
      },
      child: Column(
        children: [
          Text(widget.task.name),
          Text(widget.task.creationDate.toString()),
        ],
      ),
    );
  }
}
