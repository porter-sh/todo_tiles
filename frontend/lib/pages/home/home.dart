/// This file contains the home page, which shows the user's tasks and provides
/// filtering options. It uses a stateless widget, [HomePage], that gets its
/// data from the [TaskData] ChangeNotifier.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../task_data.dart';
import '../../types/category.dart';
import '../../types/time_horizon.dart';
import '../../components/filter_dropdown.dart';
import './task_tile.dart';
import 'category_edit_dialog.dart';

/// Public class [HomePage] is a [StatefulWidget] that creates the home page,
/// with all the tasks, and filtering options.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

/// Private class [_HomePageState] is a [State] that creates the home page for
/// the public class [HomePage].
class _HomePageState extends State<HomePage> {
  // Currently selected category filter.
  int selectedCategoryId = Category.all.id!;
  // Currently selected due date filter.
  TimeHorizon timeHorizonView = TimeHorizon.all;

  /// Returns the widget that displays the home page.
  @override
  Widget build(BuildContext context) {
    var taskData = context.watch<TaskData>();

    // Safeguard against the selected category being deleted.
    if (taskData.getCategoryById(selectedCategoryId) == null) {
      setState(() {
        selectedCategoryId = Category.all.id!;
      });
    }

    return Column(
      children: [
        // Banner at the top for selecting filters by category and due date.
        Container(
          color: Theme.of(context).colorScheme.primaryContainer,
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              // Category filter.
              FilterDropdown<Category>(
                value: taskData.getCategoryById(selectedCategoryId)!,
                items: taskData.categories,
                onChanged: (Category? newValue) {
                  setState(() {
                    selectedCategoryId = newValue!.id!;
                  });
                },
                onLongPress: ({Category? object, int? index}) {
                  // Fullscreen popup for editing the category.
                  if (index! >= 0) {
                    // Close the dropdown.
                    Navigator.of(context).pop();
                    setState(() {
                      selectedCategoryId = object!.id!;
                    });
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) =>
                          CategoryEditDialog(categoryId: object!.id!),
                    );
                  }
                },
              ),
              const SizedBox(width: 10),
              // Due date filter.
              FilterDropdown<TimeHorizon>(
                value: timeHorizonView,
                onChanged: (TimeHorizon? newValue) {
                  setState(() {
                    timeHorizonView = newValue!;
                  });
                },
                items: TimeHorizon.values,
              ),
            ],
          ),
        ),
        // Scrollable grid of tasks.
        Expanded(
          child: Container(
            color: Theme.of(context).colorScheme.background,
            child: GridView.builder(
              padding: const EdgeInsets.all(5),
              physics: const ScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
              ),
              itemCount: taskData.numTasks,
              itemBuilder: (context, index) {
                int taskId = taskData.getTaskIdByIndex(index);
                return TaskTile(taskId: taskId);
              },
            ),
          ),
        ),
      ],
    );
  }
}
