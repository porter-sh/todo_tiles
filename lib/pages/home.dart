/// This file contains the home page, which shows the user's tasks and provides
/// filtering options. It uses a stateless widget, [HomePage], that gets its
/// data from the [TaskData] ChangeNotifier.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../task_data.dart';
import '../types/category.dart';
import '../types/time_horizon.dart';
import '../util/filter_dropdown.dart';

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
  Category categoryView = Category.all;
  // Currently selected due date filter.
  TimeHorizon timeHorizonView = TimeHorizon.all;

  /// Returns the widget that displays the home page.
  @override
  Widget build(BuildContext context) {
    var taskData = context.watch<TaskData>();
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
                value: categoryView,
                items: taskData.categories,
                onChanged: (Category? newValue) {
                  setState(() {
                    categoryView = newValue!;
                  });
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
          child: GridView.builder(
            physics: const ScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
            itemCount: taskData.numTasks,
            itemBuilder: (context, index) {
              var task = taskData.tasks[index];
              return Card(
                child: Column(
                  children: [
                    Text(task.name),
                    Text(task.creationDate.toString()),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
