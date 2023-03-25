import 'dart:math';

import 'package:dinder/src/group_selection/models/group.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dinder/src/user/models/current_user.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';

class GroupSelectionService {
  Logger _logger = Logger();
  late final CollectionReference _groupsCollection;
  late final CurrentUser _currentUser;

  GroupSelectionService(CurrentUser user) {
    _currentUser = user;
    _groupsCollection = FirebaseFirestore.instance.collection('groups');
  }

  Future<List<Group>> getGroups() async {
    _logger.d("Get Groups");
    // get the groups from the firestore database where the group uid is in the current user's groups
    var userGroups = _currentUser.groups;
    // Get groups where the document id is in userGroups
    final querySnapshot = await _groupsCollection
        .where(FieldPath.documentId, whereIn: userGroups)
        .get();

    final documents = querySnapshot.docs;

    _logger.d("${documents.length} documents retrieved");

    // convert the groups to a list of Group objects
    List<Group> groupObjs = [];
    for (var document in documents) {
      Group group = Group.fromMap(document.data() as Map<String, dynamic>);
      group.id = document.id;
      groupObjs.add(group);
    }

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
    DocumentReference groupId = await _groupsCollection.add(group.toMap());
    _logger.d("Added group. Group ID: ${groupId.id}");
    group.id = groupId.id;
    return group;
  }

  Future<Group> joinGroup(String joinCode) async {
    _logger.d("Joining group with join code: $joinCode");
    // get the group from the firestore database where the group join code is the same as the join code entered
    var group =
        await _groupsCollection.where('joinCode', isEqualTo: joinCode).get();

    // if the group exists, add the current user to the group
    if (group.docs.isNotEmpty) {
      _groupsCollection.doc(group.docs.first.id).update({
        'members': FieldValue.arrayUnion([_currentUser.uid]),
      });
      _logger.d("Group members updated with current user $_currentUser.uid");
      _currentUser.addGroup(group.docs.first.id);
      _logger.d("Group added to user groups");
      return Group.fromMap(group.docs.first.data() as Map<String, dynamic>);
    } else {
      _logger.e("Group with join code {$joinCode} does not exist");
      throw Exception('Group does not exist');
    }
  }

  void leaveGroup(String uid) {
    _groupsCollection.doc(uid).update({
      'members': FieldValue.arrayRemove([_currentUser.uid]),
    });
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
