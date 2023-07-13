/// This file contains the code that creates the layout of the app. It has a
/// bottom navigation bar and a floating action button to add new tasks.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/friends.dart';
import 'pages/history.dart';
import 'pages/home.dart';
import 'pages/profile.dart';
import 'pages/settings.dart';
import 'task_data.dart';
import 'types/task.dart';

/// Public class [PageSelector] is a [StatefulWidget] that creates the layout of the
/// app with the private class [_PageSelectorState].
class PageSelector extends StatefulWidget {
  const PageSelector({super.key});

  @override
  State<PageSelector> createState() => _PageSelectorState();
}

/// Private class [_PageSelectorState] is a [State] that creates the layout of the
/// app.
class _PageSelectorState extends State<PageSelector> {
  // The index of the currently selected tab.
  int _selectedIndex = 0;

  // The list of tabs in the bottom navigation bar.
  static const List<BottomNavigationBarItem> _bottomNavBarItems = [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.history),
      label: 'History',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.people),
      label: 'Friends',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.settings),
      label: 'Settings',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: 'Profile',
    ),
  ];

  /// Called when the user taps on a tab in the bottom navigation bar.
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  /// Returns the widget that displays the navigation, and the correct page.
  @override
  Widget build(BuildContext context) {
    var taskData = context.watch<TaskData>();

    Widget page;
    switch (_selectedIndex) {
      case 0:
        page = const HomePage();
        break;
      case 1:
        page = const HistoryPage();
        break;
      case 2:
        page = const FriendsPage();
        break;
      case 3:
        page = const SettingsPage();
        break;
      case 4:
        page = const ProfilePage();
        break;
      default:
        page = const HomePage();
    }
    return Scaffold(
      body: SafeArea(child: page),
      bottomNavigationBar: BottomNavigationBar(
        items: _bottomNavBarItems,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      // Floating action button to add new tasks only on the Home page.
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                taskData.addTask(Task(name: 'Task #${taskData.numTasks + 1}'));
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
