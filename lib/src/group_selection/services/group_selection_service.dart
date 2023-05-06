import 'dart:math';

import 'package:dinder/src/group_selection/data/firebase_group_selection_data.dart';
import 'package:dinder/src/group_selection/data/group_selection_data.dart';
import 'package:dinder/src/group_selection/models/group.dart';
import 'package:dinder/src/user/models/current_user.dart';
import 'package:logger/logger.dart';

class GroupSelectionService {
  final Logger _logger = Logger();
  late final CurrentUser _currentUser;
  final GroupSelectionData _groupSelectionData = FirebaseGroupSelectionData();

  GroupSelectionService(CurrentUser user) {
    _currentUser = user;
  }

  Future<List<Group>> getGroups() async {
    _logger.d("Get Groups");
    // get the groups from the firestore database where the group uid is in the current user's groups
    var userGroups = _currentUser.groups;
    if (userGroups == null) {
      return [];
    }
    // Get groups where the document id is in userGroups
    List<Group> groupObjs = await _groupSelectionData.getGroups(userGroups);
    return groupObjs;
  }

  Future<Group> createGroup(String name) async {
    // Generate a 6 letter random string
    var joinCode = generateRandomString(6);
    _logger.d("Generated join Code: $joinCode");
    Group group = Group(
      joinCode: joinCode,
      name: name,
      members: [_currentUser.uid],
      admins: [_currentUser.uid],
      created: DateTime.now(),
      lastUpdated: DateTime.now(),
      lastUpdatedBy: _currentUser.uid,
    );
    group = await _groupSelectionData.createGroup(group);
    return group;
  }

  Future<Group> joinGroup(String joinCode) async {
    _logger.d("Joining group with join code: $joinCode");
    // get the group from the firestore database where the group join code is the same as the join code entered
    _logger.d("Group members updated with current user $_currentUser.uid");
    Group? group =
        await _groupSelectionData.joinGroup(joinCode, _currentUser.uid);
    if (group == null) {
      _logger.e("Croup with join cod $joinCode, does not exist");
      throw Exception('Group does not exist');
    }
    _currentUser.addGroup(group.id);
    _logger.e("Group with join code {$joinCode} does not exist");
    return group;
  }

  void leaveGroup(String uid) {
    _groupSelectionData.leaveGroup(uid, _currentUser.uid);
    _logger.d("Current user removed from group $uid");
  }

  String generateRandomString(int lengthOfString) {
    final random = Random();
    const allChars =
        'AaBbCcDdlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1EeFfGgHhIiJjKkL234567890';
    // below statement will generate a random string of length using the characters
    // and length provided to it
    final randomString = List.generate(lengthOfString,
        (index) => allChars[random.nextInt(allChars.length)]).join();
    return randomString; // return the generated string
  }
}
