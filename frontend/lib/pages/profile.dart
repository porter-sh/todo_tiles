/// This file contains the profile page, which shows the user's profile.

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_tiles/components/icon_text.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final user = FirebaseAuth.instance.currentUser!;
  final accessToken = FirebaseAuth.instance.currentUser!.getIdToken();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Logged in as ${user.email}"),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            child: const IconText(
              icon: Icon(Icons.logout),
              text: Text("Logout"),
              padding: EdgeInsets.all(10),
            ),
          ),
        ],
      ),
    );
  }
}
