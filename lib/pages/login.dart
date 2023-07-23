/// This file contains the [Login] page, which is the first page that the user
/// sees when they open the app. It allows the user to log in or create an
/// account.

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/OutlinedTextFormField.dart';

/// The [Login] page is the first page that the user sees when they open the
/// app. It allows the user to log in or create an account.
class Login extends StatelessWidget {
  /// Creates a [Login] page.
  Login({super.key});

  /// Text editing controllers for the email and password text fields.
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  /// Returns the widget that displays the login page.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Text(
                  'Login',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 25),
                Column(
                  children: [
                    OutlinedTextFormField(
                      text: "Email",
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 10),
                    OutlinedTextFormField(
                      text: "Password",
                      obscureText: true,
                      controller: passwordController,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Spacer(),
                        Text(
                          'Forgot password?',
                          style: Theme.of(context).textTheme.bodySmall,
                        )
                      ],
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                      ),
                      onPressed: () async {
                        // Show a loading circle.
                        showDialog(
                          context: context,
                          builder: (context) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        );

                        // Try to log in with the email and password.
                        try {
                          await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                            email: emailController.text,
                            password: passwordController.text,
                          )
                              .then((value) {
                            // Hide the loading circle.
                            Navigator.pop(context);
                          });
                        } on FirebaseAuthException catch (e) {
                          // Hide the loading circle.
                          Navigator.pop(context);

                          if (e.code == 'user-not-found') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("No user found for that email."),
                              ),
                            );
                          } else if (e.code == 'wrong-password') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Incorrect password."),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("An error occurred."),
                              ),
                            );
                          }
                        }
                      },
                      child: const Text('Login'),
                    ),
                    const SizedBox(height: 10),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                      ),
                      onPressed: () async {
                        // Show a loading circle.
                        showDialog(
                          context: context,
                          builder: (context) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        );

                        // Try to create an account with the email and password.
                        try {
                          await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                            email: emailController.text,
                            password: passwordController.text,
                          )
                              .then((value) {
                            // Hide the loading circle.
                            Navigator.pop(context);
                          });
                        } on FirebaseAuthException catch (e) {
                          // Hide the loading circle.
                          Navigator.pop(context);

                          if (e.code == 'weak-password') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("The password is too weak."),
                              ),
                            );
                          } else if (e.code == 'email-already-in-use') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    "An account already exists for that email."),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("An error occurred."),
                              ),
                            );
                          }
                        } catch (e) {
                          // Hide the loading circle.
                          Navigator.pop(context);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("An error occurred."),
                            ),
                          );
                        }
                      },
                      child: const Text('Create an account'),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                const Row(
                  children: [
                    Expanded(
                      child: Divider(),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text('OR'),
                    ),
                    Expanded(
                      child: Divider(),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                  ),
                  onPressed: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('lib/images/google.png', height: 24),
                      const SizedBox(width: 10),
                      const Text('Login with Google'),
                    ],
                  ),
                ),
                const Spacer(),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
