import 'package:dinder/src/group_selection/models/group.dart';
import 'package:dinder/src/group_selection/screens/group_settings.dart';
import 'package:dinder/src/group_selection/services/group_selection_service.dart';
import 'package:dinder/src/group_selection/widgets/group_card.dart';
import 'package:dinder/src/shared/widgets/three_dots_menu.dart';
import 'package:dinder/src/user/models/current_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class GroupSelectionHome extends StatefulWidget {
  @override
  _GroupSelectionHomeState createState() => _GroupSelectionHomeState();
}

class _GroupSelectionHomeState extends State<GroupSelectionHome> {
  final Logger _logger = Logger();
  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<CurrentUser>(context);
    final GroupSelectionService _groupSelectionService =
        GroupSelectionService(currentUser);

    void _createGroup() async {
      var group = await _groupSelectionService.createGroup('New group');

      // Move the user to the group settings page for the new group
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GroupSettings(group: group),
        ),
      );
    }

    // text controller for the join code text field
    final TextEditingController _joinCodeController = TextEditingController();

    void joinGroup() async {
      Group joinedGroup =
          await _groupSelectionService.joinGroup(_joinCodeController.text);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GroupSettings(group: joinedGroup),
        ),
      );
    }

    Future<List<Group>> getUserGroups() async {
      List<Group> groups = await _groupSelectionService.getGroups();
      return groups;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Group Selection'),
        actions: const [
          ThreeDotsMenu(),
        ],
      ),
      // page with horizontal scrollable list of groups
      // options to create new group
      // options to join group
      body: Column(
        children: [
          // Horizontal scrollable list of groups
          Container(
            height: 400,
            width: double.infinity,
            color: Colors.red,
            child: FutureBuilder(
              future: getUserGroups(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  return Center(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        setState(() {});
                      },
                      child: ListView.builder(
                        // scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return GroupCard(
                            group: snapshot.data![index],
                            currentUserId: currentUser.uid,
                          );
                        },
                      ),
                    ),
                  );
                } else if (!snapshot.hasData && !snapshot.hasError) {
                  // TODO: this is not working
                  return const Center(
                    child: Text('Create a new group or join an existing one'),
                  );
                } else if (snapshot.hasError) {
                  // log the error
                  _logger.e(snapshot.error);
                  return const Center(
                    child: Text('Error loading groups'),
                  );
                } else {
                  return const Center(
                    child: SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator()),
                  );
                }
              },
            ),
          ),
          // join group code input field
          TextField(
            controller: _joinCodeController,
            decoration: const InputDecoration(
              hintText: 'Enter group code',
            ),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  _createGroup();
                },
                child: const Text('Create Group'),
              ),
              ElevatedButton(
                onPressed: () {
                  joinGroup();
                },
                child: const Text('Join Group'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
