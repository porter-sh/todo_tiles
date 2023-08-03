/// This file contains the code for the prebuilt [ExpandableFab] widget for the
/// home page.

import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';

import 'category_edit_dialog.dart';
import 'task_tile_edit_dialog.dart';

/// Public class [HomeExpandableFab] simply builds an [ExpandableFab] with the
/// correct colors and icons for the home page.
class HomeExpandableFab extends StatelessWidget {
  const HomeExpandableFab({super.key});

  @override
  Widget build(context) {
    final key = GlobalObjectKey<ExpandableFabState>(context);
    return ExpandableFab(
      // The key is used for closing the FAB.
      key: key,
      type: ExpandableFabType.up,
      distance: 70.0,
      childrenOffset: const Offset(0, -5.0),
      // Grey out the background when the FAB is expanded.
      overlayStyle: ExpandableFabOverlayStyle(
          color: Theme.of(context).colorScheme.scrim.withOpacity(0.15)),
      // Button to open the expanded menu.
      openButtonBuilder: RotateFloatingActionButtonBuilder(
        child: const Icon(Icons.add),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      // Button to close the expanded menu.
      closeButtonBuilder: RotateFloatingActionButtonBuilder(
        child: const Icon(Icons.close),
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
      ),
      // The buttons in the FAB.
      children: [
        ExpandedFabButton(
            icon: const Icon(Icons.task),
            label: const Text('Task'),
            onPressed: () {
              // Close the FAB.
              final state = key.currentState;
              if (state != null && state.isOpen) {
                state.toggle();
              }
              // Fullscreen popup for editing the task. TaskTileEditDialog takes
              // no parameter in order to create the task.
              showDialog<String>(
                context: context,
                builder: (BuildContext context) => const TaskTileEditDialog(),
              );
            }),
        ExpandedFabButton(
            icon: const Icon(Icons.category),
            label: const Text('Category'),
            onPressed: () {
              // Close the FAB.
              final state = key.currentState;
              if (state != null && state.isOpen) {
                state.toggle();
              }
              // Fullscreen popup for editing the category. CategoryEditDialog
              // takes no parameter in order to create the category.
              showDialog<String>(
                context: context,
                builder: (BuildContext context) => const CategoryEditDialog(),
              );
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
