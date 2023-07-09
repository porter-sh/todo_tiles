/// This file contains the code that creates the layout of the app. It has a
/// bottom navigation bar and a floating action button to add new tasks.

import 'package:flutter/material.dart';

/// Public class [PageSelector] is a [StatefulWidget] that creates the layout of the
/// app with the private class [_PageSelectorState].
class PageSelector extends StatefulWidget {
  const PageSelector({Key? key}) : super(key: key);

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
    return Scaffold(
      body: const Placeholder(),
      bottomNavigationBar: BottomNavigationBar(
        items: _bottomNavBarItems,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
