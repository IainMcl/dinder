import 'package:dinder/src/user/screens/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dinder/src/user/models/user.dart';
import 'package:logger/logger.dart';

class ThreeDotsMenu extends StatelessWidget {
  const ThreeDotsMenu({super.key});
  @override
  Widget build(BuildContext context) {
    final Logger _logger = Logger();

    return PopupMenuButton(
      offset: const Offset(0, 56),
      itemBuilder: (context) => [
        PopupMenuItem(
          // Profile page
          onTap: () {
            _logger.d("Profile page");
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const Profile()));
          },
          child: Row(children: const [
            Icon(Icons.manage_accounts, color: Colors.black),
            SizedBox(width: 12),
            Text("Profile"),
          ]),
        ),
        PopupMenuItem(
          // Firebase sign out
          onTap: () {
            FirebaseAuth.instance.signOut();
          },
          child: Row(children: const [
            Icon(Icons.logout, color: Colors.black),
            SizedBox(width: 12),
            Text("Logout"),
          ]),
        ),
      ],
    );
  }
}
