/// This file contains the code that creates the layout of the app. It has a
/// bottom navigation bar and a floating action button to add new tasks.

import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';

import 'pages/friends.dart';
import 'pages/history.dart';
import 'pages/home/home.dart';
import 'pages/profile.dart';
import 'pages/settings.dart';
import 'pages/home/home_expandable_fab.dart';

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

  // List of the details of the tabs in the bottom navigation bar.
  static final _bottomNavBarItems = [
    [const Icon(Icons.home), 'Home'],
    [const Icon(Icons.history), 'History'],
    [const Icon(Icons.people), 'Friends'],
    [const Icon(Icons.settings), 'Settings'],
    [const Icon(Icons.person), 'Profile'],
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
        items: _bottomNavBarItems.map((item) {
          return BottomNavigationBarItem(
            icon: item[0] as Icon,
            label: item[1] as String,
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          );
        }).toList(),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        fixedColor: Theme.of(context).colorScheme.onPrimaryContainer,
        unselectedItemColor: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
      // Floating action button to add new tasks only on the Home page.
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton:
          _selectedIndex == 0 ? const HomeExpandableFab() : null,
    );
  }
}
