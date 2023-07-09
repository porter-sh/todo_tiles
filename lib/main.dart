import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'page_selector.dart';
import 'task_data.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TaskData(),
      child: MaterialApp(
        // Material3 Theme
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.blue,
          ),
          useMaterial3: true,
        ),
        home: const PageSelector(),
      ),
    );
  }
}
