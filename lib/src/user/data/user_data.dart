import 'package:dinder/src/user/models/user.dart';

abstract class UserData{
  Future<User> getUser(String id);
  Future<void> saveUser(User user);
  Future<void> deleteUser(String id);
  Future<void> updateUser(User user);
  Future<List<User>> getUsers(List<String> ids);
}
