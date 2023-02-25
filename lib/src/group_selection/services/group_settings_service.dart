import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dinder/src/group_selection/models/group.dart';

class GroupSettingsService {
  Group group;
  // Document reference for the firebase firestore document for the group
  late final DocumentReference _groupDocRef;

  GroupSettingsService({required this.group}) {
    // _groupDocRef =
    //     FirebaseFirestore.instance.collection('groups').doc(group.id);
  }

  Future<String> updateGroupName(String name) async {
    // Update the group name in the firebase firestore document if the current user is a member of the group
    // var currentUserId = await
    // await _groupDocRef.update({
    //   'name': name,
    // });

    // Get the updated group name from the firebase firestore document
    // var groupDoc = await _groupDocRef.get();
    // var groupName = groupDoc.data['name'];

    // return groupName;
    return Future<String>.value(name);
  }

  // String getGroupInviteCode() {
  // }
}
