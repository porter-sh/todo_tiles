/// This file contains the [Login] page, which is the first page that the user
/// sees when they open the app. It allows the user to log in or create an
/// account.

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../components/outlined_text_form_field.dart';

/// The [Login] page is the first page that the user sees when they open the
/// app. It allows the user to log in or create an account.
class Login extends StatefulWidget {
  /// Creates a [Login] page.
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  /// Text editing controllers for the email and password text fields.
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  /// Whether the user is creating a new account.
  bool creatingAccount = false;

  /// Switch between the login and create account pages.
  void toggleView() {
    setState(() {
      creatingAccount = !creatingAccount;
    });
  }

  /// Log the user in.
  void login({required BuildContext context}) async {
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
        showError(context: context, message: "No user found for that email.");
      } else if (e.code == 'wrong-password') {
        showError(context: context, message: "Incorrect password.");
      } else {
        showError(context: context, message: "An error occurred.");
      }
    }
  }

  /// Create a new account.
  void createAccount({required BuildContext context}) async {
    // Check that the passwords match.
    if (passwordController.text != confirmPasswordController.text) {
      showError(context: context, message: "Passwords do not match.");
      return;
    }

    // Show a loading circle.
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    // Try to create a new account with the email and password.
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      // Hide the loading circle.
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // Hide the loading circle.
      Navigator.pop(context);

      if (e.code == 'weak-password') {
        showError(
            context: context, message: "The password provided is too weak.");
      } else if (e.code == 'email-already-in-use') {
        showError(
            context: context,
            message: "An account already exists for that email.");
      } else {
        showError(context: context, message: "An error occurred.");
      }
    }
  }

  /// Sign in or create an account with Google.
  void signInWithGoogle({required BuildContext context}) async {
    // Start the sign-in process.
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
    // Get the authentication details from the request.
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;
    // Create a new credential.
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    // Sign in to Firebase with the Google credential.
    await FirebaseAuth.instance.signInWithCredential(credential);
  }

  /// Show an error message to the user.
  void showError({required BuildContext context, required String message}) {
    // Hide the previous snackbar.
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  /// Returns the widget that displays the login page.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      creatingAccount ? 'Create Account' : 'Login',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 25),
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
                    // Extra password field when creating an account.
                    if (creatingAccount)
                      OutlinedTextFormField(
                        text: "Confirm Password",
                        obscureText: true,
                        controller: confirmPasswordController,
                      ),
                    if (creatingAccount) const SizedBox(height: 10),
                    if (!creatingAccount)
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
                      onPressed: () {
                        if (creatingAccount) {
                          toggleView();
                        } else {
                          login(context: context);
                        }
                      },
                      child: Text(creatingAccount ? 'Sign up' : 'Login'),
                    ),
                    const SizedBox(height: 25),
                    const Row(
                      children: [
                        Expanded(
                          child: Divider(),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text('or'),
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
                      onPressed: () => signInWithGoogle(context: context),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('lib/images/google.png', height: 24),
                          const SizedBox(width: 10),
                          const Text('Continue with Google'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          creatingAccount
                              ? 'Already have an account? '
                              : 'Not signed up? ',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        GestureDetector(
                            onTap: () => toggleView(),
                            child: Text(
                              creatingAccount ? 'Login.' : 'Create an account.',
                              style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ))
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
