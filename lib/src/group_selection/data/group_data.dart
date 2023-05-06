import 'package:dinder/src/group_selection/models/group.dart';

abstract class GroupData{
  Future<void> updateGroup(Group group);
  Future<void> deleteGroup(String groupId);
  Future<Group?> getGroupById(String groupId); 
}
