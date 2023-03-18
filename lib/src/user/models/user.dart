import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dinder/src/user/models/dietary_requirements.dart';

class User {
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
    DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection("users").doc(id).get();
    return User.fromDocument(doc);
  }

  static Future<List<User>> getUsers(List<String> ids) async {
    List<User> users = [];
    for (String id in ids) {
      users.add(await getUser(id));
    }
    return users;
  }

  void saveUser() {
    FirebaseFirestore.instance.collection("users").doc(_id).set(toMap());
  }

  delete() {
    // TODO: Delete all groups that the user the only admin in
    FirebaseFirestore.instance.collection("users").doc(_id).delete();
  }
}
