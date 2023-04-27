import 'package:dinder/src/group_selection/models/group.dart';

abstract class GroupSelectionData{
  Future<List<Group>> getGroups(List<String> groupIds);
  Future<Group> createGroup(Group group);
  Future<Group?> joinGroup(String joinCode, String userId);
  void leaveGroup(String groupId, String userId);
}
