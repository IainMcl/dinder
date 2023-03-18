import 'package:dinder/src/group_selection/models/group.dart';
import 'package:dinder/src/group_selection/screens/group_selection_home.dart';
import 'package:dinder/src/shared/widgets/confirmation_dialog.dart';
import 'package:dinder/src/user/models/user.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class MemberListItem extends StatelessWidget {
  User user;
  bool isAdmin;
  bool isCurrentUserAdmin;
  Group group;
  MemberListItem(
      {Key? key,
      required this.user,
      required this.group,
      this.isAdmin = false,
      this.isCurrentUserAdmin = false})
      : super(key: key);

  final Logger _logger = Logger();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          RichText(
            text: TextSpan(
              text: user.name ?? user.email!,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              children: const <TextSpan>[
                TextSpan(
                  text: ' (admin)',
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.normal,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          if (isCurrentUserAdmin) // TODO: Or current user is the user

            IconButton(
              onPressed: () {
                String title;
                String message;
                if (group.members.length == 1) {
                  title = "Delete group";
                  message = "Are you sure you want to delete this group?";
                } // TODO: If current user is the user
                else {
                  title = "Remove user from group";
                  message = "Are you sure you want to remove this user?";
                }

                // Push to the current context
                showDialog(
                    context: context,
                    builder: (context) => ConfirmationDialog(
                          title: title,
                          message: message,
                          onConfirm: () {
                            group.removeMember(user.id);
                            _logger.d("Removed user from group members list");
                            if (group.members.isEmpty) {
                              group.delete();
                              // Pop the context back to the group selection home screen
                              // TODO: Implement this with routes
                              Navigator.popUntil(
                                  context,
                                  (route) =>
                                      route.settings.name ==
                                      "/group_selection");
                            }
                            Navigator.pop(context);
                          },
                          onCancel: () {
                            _logger.d(
                                "Cancelled removal of user from group members list");
                            Navigator.pop(context);
                          },
                        ));
              },
              icon: const Icon(Icons.delete, size: 18),
            ),
        ],
      ),
    );
  }
}
