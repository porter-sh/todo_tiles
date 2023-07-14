/// This file contains the code for the prebuilt [ExpandableFab] widget for the
/// home page.

import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:provider/provider.dart';

import '../task_data.dart';
import '../types/category.dart';
import '../types/task.dart';

/// Public class [HomeExpandableFab] simply builds an [ExpandableFab] with the
/// correct colors and icons for the home page.
class HomeExpandableFab extends StatelessWidget {
  const HomeExpandableFab({super.key});

  @override
  Widget build(context) {
    var taskData = context.watch<TaskData>();
    return ExpandableFab(
      type: ExpandableFabType.up,
      distance: 70.0,
      childrenOffset: const Offset(0, -5.0),
      // Grey out the background when the FAB is expanded.
      overlayStyle: ExpandableFabOverlayStyle(
          color: Theme.of(context).colorScheme.scrim.withOpacity(0.15)),
      // Button to close the expanded menu.
      closeButtonStyle: ExpandableFabCloseButtonStyle(
        child: const Icon(Icons.close),
        foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      ),
      // Button to open the expanded menu.
      child: const Icon(Icons.add),
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      // The buttons in the FAB.
      children: [
        ExpandedFabButton(
            icon: const Icon(Icons.task),
            label: const Text('Task'),
            onPressed: () {
              taskData.addTask(Task(name: 'New Task'));
            }),
        ExpandedFabButton(
            icon: const Icon(Icons.category),
            label: const Text('Category'),
            onPressed: () {
              taskData.addCategory(const Category(name: 'New Category'));
            }),
        ExpandedFabButton(
            icon: const Icon(Icons.show_chart),
            label: const Text('Series'),
            onPressed: () {
              // TODO
            }),
        ExpandedFabButton(
            icon: const Icon(Icons.flag),
            label: const Text('Goal'),
            onPressed: () {
              // TODO
            }),
      ],
    );
  }
}

class ExpandedFabButton extends StatelessWidget {
  const ExpandedFabButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final Icon icon;
  final Text label;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      heroTag: null,
      icon: icon,
      label: label,
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
      onPressed: () {
        onPressed();
      },
    );
  }
}
