import 'package:dinder/src/group_selection/models/group.dart';
import 'package:dinder/src/group_selection/screens/group_selection_home.dart';
import 'package:dinder/src/shared/widgets/confirmation_dialog.dart';
import 'package:dinder/src/user/models/current_user.dart';
import 'package:dinder/src/user/models/user.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class MemberListItem extends StatelessWidget {
  final User user;
  final bool isAdmin;
  final Group group;
  MemberListItem({
    Key? key,
    required this.user,
    required this.group,
    this.isAdmin = false,
  }) : super(key: key);

  final Logger _logger = Logger();

  @override
  Widget build(BuildContext context) {
    CurrentUser currentUser = Provider.of<CurrentUser>(context);
    final bool currentUserIsGroupAdmin = group.admins.contains(currentUser.uid);
    final bool currentUserIsUser = currentUser.uid == user.id;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          RichText(
            text: TextSpan(
              text: user.name ?? user.email!,
              style: TextStyle(
                color: Colors.black,
                fontWeight:
                    currentUserIsUser ? FontWeight.bold : FontWeight.normal,
              ),
              children: const <TextSpan>[
                // if (currentUserIsGroupAdmin)
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
          // if (currentUserIsGroupAdmin || currentUserIsUser)
          //   Container(
          //     color: Colors.red,
          //     child: IconButton(
          //       onPressed: () {},
          //       icon: const Icon(Icons.edit, size: 18),
          //     ),
          //   ),
          if (currentUserIsGroupAdmin || currentUserIsUser)
            IconButton(
              onPressed: () {
                String title;
                String message;
                if (group.members.length == 1) {
                  title = "Delete group";
                  message = "Are you sure you want to delete this group?";
                } else if (currentUserIsUser) {
                  title = "Leave group";
                  message = "Are you sure you want to leave this group?";
                } else {
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
                            group.removeMember(user.id, currentUser);
                            _logger.d("Removed user from group members list");
                            if (group.members.isEmpty) {
                              group.delete();
                              // Pop the context back to the group selection home screen
                              // TODO: Implement this with routes
                              // Navigator.popUntil(
                              //     context,
                              //     (route) =>
                              //         route.settings.name ==
                              //         "/group_selection");
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const GroupSelectionHome()),
                                  (route) => false);
                              return;
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
