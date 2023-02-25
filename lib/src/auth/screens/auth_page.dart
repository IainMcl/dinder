import 'package:dinder/src/auth/screens/login.dart';
import 'package:dinder/src/group_selection/screens/group_selection_home.dart';
import 'package:dinder/src/selection/screens/selection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GroupSelectionHome();
          } else {
            return const Login();
          }
        },
      ),
    );
  }
}
