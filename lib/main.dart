import 'package:flutter/material.dart';

import 'PageSelector.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Material3 Theme
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blue,
        ),
        useMaterial3: true,
      ),
      home: const PageSelector(),
    );
  }
}
