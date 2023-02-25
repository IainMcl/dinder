import 'dart:math';

import 'package:dinder/src/group_selection/models/group.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dinder/src/user/models/current_user.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';

class GroupSelectionService {
  late final CollectionReference _groupsCollection;
  late final CurrentUser _currentUser;

  GroupSelectionService() {
    _groupsCollection = FirebaseFirestore.instance.collection('groups');
    _currentUser = CurrentUser();
  }
  Future<void> init() async {
    await _currentUser.init();
  }

  Future<List<Group>> getGroups() async {
    // get the groups from the firestore database where the group uid is in the current user's groups
    var userGroups = _currentUser.groups;
    final querySnapshot = await _groupsCollection.get();

    final documents = querySnapshot.docs;

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
    group.id = groupId.id;
    return group;
  }

  Future<Group> joinGroup(String joinCode) async {
    // get the group from the firestore database where the group join code is the same as the join code entered
    var group =
        await _groupsCollection.where('joinCode', isEqualTo: joinCode).get();

    // if the group exists, add the current user to the group
    if (group.docs.isNotEmpty) {
      _groupsCollection.doc(group.docs.first.id).update({
        'members': FieldValue.arrayUnion([_currentUser.uid]),
      });
      return Group.fromMap(group.docs.first.data() as Map<String, dynamic>);
    } else {
      throw Exception('Group does not exist');
    }
  }

  void leaveGroup(String uid) {
    _groupsCollection.doc(uid).update({
      'members': FieldValue.arrayRemove([_currentUser.uid]),
    });
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
