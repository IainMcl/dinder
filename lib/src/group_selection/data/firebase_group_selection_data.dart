import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dinder/src/group_selection/data/group_selection_data.dart';
import 'package:dinder/src/group_selection/models/group.dart';
import 'package:logger/logger.dart';

class FirebaseGroupSelectionData implements GroupSelectionData {
  late final CollectionReference _groupsCollection;
  final Logger _logger = Logger();

  FirebaseGroupSelectionData() {
    _groupsCollection = FirebaseFirestore.instance.collection('groups');
  }

  @override
  Future<Group> createGroup(Group group) async {
    DocumentReference groupId = await _groupsCollection.add(group.toMap());
    _logger.d("Added group. Group ID: ${groupId.id}");
    group.id = groupId.id;
    return group;
  }

  @override
  Future<List<Group>> getGroups(List<String> groupIds) async {
    final querySnapshot = await _groupsCollection
        .where(FieldPath.documentId, whereIn: groupIds)
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

  @override
  Future<Group?> joinGroup(String joinCode, String userId) async {
    var group =
        await _groupsCollection.where('joinCode', isEqualTo: joinCode).get();

    // if the group exists, add the current user to the group
    if (group.docs.isNotEmpty) {
      _groupsCollection.doc(group.docs.first.id).update({
        'members': FieldValue.arrayUnion([userId]),
      });
    _logger.d("Group added to user groups");
    return Group.fromMap(group.docs.first.data() as Map<String, dynamic>);
    } else{
      return null;
    }
  }

  @override
  void leaveGroup(String groupId, String userId) {
    _groupsCollection.doc(groupId).update({
      'members': FieldValue.arrayRemove([userId]),
    });
  }
}
