/// This file contains the home page, which shows the user's tasks and provides
/// filtering options. It uses a stateless widget, [HomePage], that gets its
/// data from the [TaskData] ChangeNotifier.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../task_data.dart';
import '../types/task.dart';

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
  /// Returns the widget that displays the home page.
  @override
  Widget build(BuildContext context) {
    var taskData = context.watch<TaskData>();

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Home Page"),
          Text("There are ${taskData.numTasks} tasks."),
          FloatingActionButton(
            onPressed: () {
              taskData.addTask(Task(name: "New Task"));
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
