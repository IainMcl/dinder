import 'package:dinder/src/auth/screens/login.dart';
import 'package:dinder/src/group_selection/screens/group_selection_home.dart';
import 'package:dinder/src/user/models/current_user.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CurrentUser>(context);
    return Scaffold(
      body: StreamBuilder<firebase_auth.User?>(
        stream: firebase_auth.FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // At this point, the user is logged in.
            // Create the current user object and track it in the provider.
            if (!user.initialized) {
              user.init();
            }
            return GroupSelectionHome();
          } else {
            return const Login();
          }
        },
      ),
    );
  }
}
