import 'package:dinder/src/group_selection/models/group.dart';
import 'package:dinder/src/group_selection/widgets/member_list_item.dart';
import 'package:dinder/src/user/models/current_user.dart';
import 'package:dinder/src/user/models/user.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class EditGroupPage extends StatefulWidget {
  Group group;

  EditGroupPage({Key? key, required this.group}) : super(key: key);

  @override
  _EditGroupPageState createState() => _EditGroupPageState();
}

class _EditGroupPageState extends State<EditGroupPage> {
  final Logger _logger = Logger();
  final TextEditingController _groupNameController = TextEditingController();
  final TextEditingController _mealDateController = TextEditingController();

  bool _isExpanded = false;
  int getNumberOfMembers() {
    return widget.group.members.length;
  }

  @override
  Widget build(BuildContext context) {
    CurrentUser currentUser = Provider.of<CurrentUser>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.group.name ?? "Group Name",
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.group.name ?? "Enter group name",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8.0),
            TextField(
              controller: _groupNameController,
              decoration: InputDecoration(
                hintText: 'Enter group name',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: 'Join Code: ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                      ),
                    ),
                    TextSpan(
                      text: widget.group.joinCode,
                      style: TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey[600],
                      ),
                    ),
                  ]),
                ),
                // Clip board to copy join code to clipboard
                IconButton(
                  icon: Icon(Icons.copy, color: Colors.grey[600], size: 18.0),
                  onPressed: () async {
                    await Clipboard.setData(
                        ClipboardData(text: widget.group.joinCode));
                    // FlutterClipboard.send(widget.group.joinCode);
                    _logger.i(
                        "Copied join code to clipboard: ${widget.group.joinCode}");
                  },
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Text(
              'Members (${getNumberOfMembers()})',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8.0),
            GestureDetector(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _isExpanded ? 'Hide All' : 'Show All',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        _isExpanded ? Icons.expand_less : Icons.expand_more,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_isExpanded)
              // Future List view of members
              FutureBuilder(
                future: User.getUsers(widget.group.members),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return MemberListItem(
                          group: widget.group,
                          user: snapshot.data[index],
                          isAdmin: widget.group.admins
                              .contains(snapshot.data[index].id),
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            const SizedBox(height: 16.0),
            Text(
              'Meal Date',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8.0),
            TextField(
              controller: _mealDateController,
              decoration: InputDecoration(
                hintText: 'Enter meal date',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 32.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Perform action on reset button press
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Colors.grey[400],
                    ),
                  ),
                  child: const Text('Reset'),
                ),
                ElevatedButton(
                  child: const Text('Continue'),
                  onPressed: () {
                    // Perform action on continue button press
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
