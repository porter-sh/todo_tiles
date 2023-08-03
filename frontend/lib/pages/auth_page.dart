/// This file contains the [AuthPage] widget, which decides whether to show the
/// [Login] page or the [Home] page, based on whether the user is logged in.

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../page_selector.dart';
import 'login.dart';

/// Public class [AuthPage] is a [StatelessWidget] that decides whether to show
/// the [Login] page or the [Home] page, based on whether the user is logged in.
class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  /// Returns the widget that displays the login page or the home page.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.idTokenChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final user = snapshot.data;
            if (user == null) {
              return const Login();
            }
            return const PageSelector();
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
