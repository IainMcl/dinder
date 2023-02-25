import 'package:dinder/src/group_selection/models/group.dart';
import 'package:dinder/src/group_selection/widgets/member_dropdown.dart';
import 'package:dinder/src/selection/screens/selection.dart';
import 'package:dinder/src/shared/widgets/edit_success.dart';
import 'package:dinder/src/shared/widgets/three_dots_menu.dart';
import 'package:dinder/src/user/models/current_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_focus_watcher/flutter_focus_watcher.dart';

class GroupSettings extends StatefulWidget {
  Group group;

  GroupSettings({Key? key, required this.group}) : super(key: key);

  @override
  _GroupSettingsState createState() => _GroupSettingsState();
}

class _GroupSettingsState extends State<GroupSettings> {
  late TextEditingController _groupTitleController;
  bool _isEnabled = false;

  @override
  void initState() {
    super.initState();
    _groupTitleController = TextEditingController(text: "Enter group name");
  }

  final GlobalKey<EditSuccessState> editSuccessKey =
      GlobalKey<EditSuccessState>();

  void toggleEditSuccessState() {
    editSuccessKey.currentState?.toggleState();
  }

  var _currIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SizedBox(
                width: 250,
                child: Focus(
                  onFocusChange: (hasFocus) {
                    if (hasFocus) {
                      setState(() {
                        _isEnabled = true;
                      });
                      toggleEditSuccessState();
                    } else {
                      setState(() {
                        // toggle the state of the edit success widget
                        _isEnabled = false;
                      });
                      toggleEditSuccessState();
                    }
                  },
                  child: TextField(
                    cursorColor: Colors.white,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        // italic if editing
                        fontStyle:
                            _isEnabled ? FontStyle.italic : FontStyle.normal),
                    controller: _groupTitleController,
                    enabled: _isEnabled,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      suffixIcon: EditSuccess(key: editSuccessKey),
                    ),
                  ),
                )),
          ],
        ),
        actions: [ThreeDotsMenu()],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Display the group name in an editable text field
            TextField(
              controller: _groupTitleController,
              enabled: true,
            ),
            // Group join code
            Text("Join code: ${widget.group.joinCode}"),
            // // Members list in the form members (number of members) > expandable to show all members
            Text("Members: ${widget.group.members.length}"),
            MembersDropdown(memberIds: widget.group.members),
            // Admins list in the form admins (number of admins) > expandable to show all admins
            Text("Admins: ${widget.group.admins.length}"),
            MembersDropdown(memberIds: widget.group.admins),

            // Meal date
            Text("Meal date: ${widget.group.mealDate ?? "Not set"}"),

            // Continue button to go to the selection screen
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Selection(
                      group: widget.group,
                    ),
                  ),
                );
              },
              child: Text("Continue"),
            ),
          ],
        ),
      ),
    );
  }
}
