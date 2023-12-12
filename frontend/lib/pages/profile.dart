/// This file contains the profile page, which shows the user's profile.

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_tiles/components/icon_text.dart';

import '../util/api.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Logged in as ${user.email}"),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () async {
              var response = API.get(
                path: 'users/${user.uid}',
              );
              print(await response);
            },
            child: const IconText(
              icon: Icon(Icons.api),
              text: Text("Test API"),
              padding: EdgeInsets.all(10),
            ),
          ),
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
