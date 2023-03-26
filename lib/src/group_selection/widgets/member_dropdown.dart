import 'package:dinder/src/user/models/user.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class MembersDropdown extends StatefulWidget {
  final List<String> memberIds;

  const MembersDropdown({super.key, required this.memberIds});

  @override
  _MembersDropdownState createState() => _MembersDropdownState();
}

class _MembersDropdownState extends State<MembersDropdown> {
  final Logger _logger = Logger();
  Future<List<User>> _getUsers() async {
    List<User> users = [];
    for (String id in widget.memberIds) {
      User user = await User.getUser(id);
      users.add(user);
    }
    return users;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getUsers(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return DropdownButton(
            items: snapshot.data
                .map<DropdownMenuItem<String>>(
                    (User user) => DropdownMenuItem<String>(
                          value: user.id,
                          child: Text(user.id),
                        ))
                .toList(),
            onChanged: (String? value) {
              _logger.d(value);
            },
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
