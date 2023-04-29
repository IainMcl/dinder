import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dinder/src/user/data/firebase_user_data.dart';
import 'package:dinder/src/user/data/user_data.dart';
import 'package:dinder/src/user/models/dietary_requirements.dart';
import 'package:logger/logger.dart';

class User {
  final Logger _logger = Logger();
  final UserData _userData = FirebaseUserData();
  late final String _id;
  String? name;
  String? email;
  List<String>? groups;
  DietaryRequirements? dietaryRequirements;
  User({this.name, this.email, this.groups, this.dietaryRequirements});

  String get id => _id;

  // setter for id
  set id(String id) => _id = id;

  factory User.fromDocument(DocumentSnapshot doc) {
    User user = User(
      name: doc.get("name"),
      email: doc.get("email"),
      groups: List<String>.from(doc.get("groups") ?? []),
      dietaryRequirements:
          DietaryRequirements.fromDocument(doc.get("dietaryRequirements")),
    );
    user.id = doc.id;
    return user;
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "email": email,
      "groups": groups,
      "dietaryRequirements": dietaryRequirements?.toMap(),
    };
  }

  static Future<User> getUser(String id) async {
    UserData userData = FirebaseUserData();
    User user = await userData.getUser(id);
    return user;
  }

  static Future<List<User>> getUsers(List<String> ids) async {
    Logger logger = Logger();
    List<User> users = [];
    for (String id in ids) {
      try {
        users.add(await getUser(id));
      } catch (e) {
        logger.e(e);
      }
    }
    return users;
  }

  void saveUser() {
    _userData.saveUser(this);
  }

  delete() {
    // TODO: Delete all groups that the user the only admin in
    _userData.deleteUser(_id);
  }
}
