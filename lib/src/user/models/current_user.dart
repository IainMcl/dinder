import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dinder/src/user/models/dietary_requirements.dart';
import 'package:dinder/src/user/models/user.dart' as account_user;
import 'package:firebase_auth/firebase_auth.dart';

class CurrentUser {
  late final account_user.User _user;
  bool initialized = false;

  Future<void> init() async {
    // Get the current logged in user from firebase and create a user object
    FirebaseAuth auth = FirebaseAuth.instance;
    var userCollection = FirebaseFirestore.instance.collection('users');
    var doc = await userCollection.doc(auth.currentUser!.uid).get();
    _user = account_user.User.fromDocument(doc);
    initialized = true;
  }

  // Getters
  account_user.User get user => _user;
  String get uid => _user.id;
  String? get name => _user.name;
  String? get email => _user.email;
  List<String>? get groups => _user.groups;
  DietaryRequirements? get dietaryRequirements => _user.dietaryRequirements;

  // Setters
  set name(String? name) => _user.name = name;
  set email(String? email) => _user.email = email;
  set groups(List<String>? groups) => _user.groups = groups;
  set dietaryRequirements(DietaryRequirements? dietaryRequirements) =>
      _user.dietaryRequirements = dietaryRequirements;

  // Methods
  void update() {
    // Update the user in the database
    FirebaseFirestore.instance
        .collection('users')
        .doc(_user.id)
        .update(_user.toMap());
  }

  void addGroup(String groupId) {
    // Add the group to the user's list of groups
    _user.groups!.add(groupId);
    update();
  }

  void removeGroup(String groupId) {
    // Remove the group from the user's list of groups
    _user.groups!.remove(groupId);
    update();
  }

  void addDietaryRequirement(String requirement) {
    // Add the dietary requirement to the user's list of dietary requirements
    switch (requirement) {
      case 'Vegetarian':
        _user.dietaryRequirements!.vegetarian = true;
        break;
      case 'Vegan':
        _user.dietaryRequirements!.vegan = true;
        break;
      case 'Gluten Free':
        _user.dietaryRequirements!.glutenFree = true;
        break;
      case 'Lactose Free':
        _user.dietaryRequirements!.dairyFree = true;
        break;
      case 'Nut Free':
        _user.dietaryRequirements!.nutFree = true;
        break;
      case 'Halal':
        _user.dietaryRequirements!.halal = true;
        break;
      case 'Kosher':
        _user.dietaryRequirements!.kosher = true;
        break;
      case 'Pescatarian':
        _user.dietaryRequirements!.pescatarian = true;
        break;
    }

    update();
  }
}
