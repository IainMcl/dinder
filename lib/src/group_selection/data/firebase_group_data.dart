import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dinder/src/group_selection/data/group_data.dart';
import 'package:dinder/src/group_selection/models/group.dart';
import 'package:logger/logger.dart';

class FirebaseGroupData implements GroupData {
  final Logger _logger = Logger();
  @override
  Future<void> deleteGroup(String groupId) async{
      await FirebaseFirestore.instance
          .collection('groups')
          .doc(groupId)
          .delete()
          .catchError((error) {
        _logger.e("Error deleting group $groupId: $error");
      });
      _logger.d("Deleted group $groupId");
  }

  @override
  Future<void> updateGroup(Group group) async {
    await FirebaseFirestore.instance
        .collection('groups')
        .doc(group.id)
        .update(group.toMap())
        .onError((error, stackTrace) =>
            {_logger.e("Error updating group: $error : $stackTrace")});
    _logger.i("Updated group ${group.id}");
  }

  @override
  Future<Group?> getGroupById(String groupId) async{

    var groupCollection = FirebaseFirestore.instance.collection('groups');
    var groupDoc = await groupCollection.doc(groupId).get();

    if (!groupDoc.exists) return null;

    Group group = Group.fromMap(groupDoc.data()!);
  }
}
