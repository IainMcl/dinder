import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dinder/src/user/data/user_data.dart';
import 'package:dinder/src/user/models/user.dart';
import 'package:logger/logger.dart';

class FirebaseUserData implements UserData{
  final Logger _logger = Logger();

  @override
  Future<void> deleteUser(String id) async {
    await FirebaseFirestore.instance.collection("users").doc(id).delete();
  }

  @override
  Future<User> getUser(String id) async{
    DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection("users").doc(id).get();
    return User.fromDocument(doc);
  }

  @override 
  Future<List<User>> getUsers(List<String> id) async{
    throw UnimplementedError();
  }

  @override
  Future<void> saveUser(User user) async{
    await FirebaseFirestore.instance.collection("users").doc(user.id).set(user.toMap());
  }

  @override
  Future<void> updateUser(User user) async{
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.id)
        .update(user.toMap());
  }
}
