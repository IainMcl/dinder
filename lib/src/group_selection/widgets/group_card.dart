import 'package:dinder/src/group_selection/models/group.dart';
import 'package:dinder/src/group_selection/screens/group_settings2.dart';
import 'package:flutter/material.dart';

class GroupCard extends StatelessWidget {
  const GroupCard({Key? key, required this.group, required this.currentUserId})
      : super(key: key);

  final Group group;
  final String currentUserId;

  @override
  Widget build(BuildContext context) {
    // Rectangular card with group name and number of members over a background image
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                EditGroupPage(group: group), // GroupSettings(group: group),
          ),
        );
      },
      child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: SizedBox(
            height: 100,
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  // Image
                  // Image.network(
                  //   'https://picsum.photos/200/300',
                  //   fit: BoxFit.fill,
                  //   opacity: const AlwaysStoppedAnimation(.5),
                  // ),
                  // Group name
                  Text(group.name ?? ''),
                  // Number of members
                  Text(group.members.length.toString()),
                  if (group.admins.contains(currentUserId))
                    Text('You are an admin of this group')
                  else
                    Text('You are not an admin of this group')
                ],
              ),
            ),
          )),
    );
  }
}
