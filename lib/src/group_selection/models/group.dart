import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dinder/src/group_selection/models/meal_likes.dart';
import 'package:dinder/src/selection/models/meal.dart';
import 'package:dinder/src/user/models/current_user.dart';
import 'package:logger/logger.dart';

class Group {
  final Logger _logger = Logger();

  final String joinCode;
  String? name;
  List<String> members;
  List<String> admins;
  DateTime created;
  DateTime lastUpdated;
  String lastUpdatedBy;
  DateTime? mealDate;
  List<MealLikes>? mealLikes; // Meal ID, User ID

  late String _id;

  Group({
    required this.joinCode,
    this.name,
    required this.members,
    required this.admins,
    required this.created,
    required this.lastUpdated,
    required this.lastUpdatedBy,
    this.mealDate,
    this.mealLikes,
  });

  // Stream to monitor changes in the group matches
  final _mealMatchController = StreamController<Meal>.broadcast();

  Stream<Meal> get mealMatchStream => _mealMatchController.stream;

  void dispose() {
    _mealMatchController.close();
  }

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      joinCode: json['joinCode'],
      name: json['name'],
      members: json['members'],
      admins: json['admins'],
      created: json['created'],
      lastUpdated: json['lastUpdated'],
      lastUpdatedBy: json['lastUpdatedBy'],
      mealDate: json['mealDate'],
      mealLikes: json['mealLikes'],
    );
  }

  static Group fromMap(Map<String, dynamic> map) {
    var members = List<String>.from(map['members']);
    var admins = List<String>.from(map['admins']);
    var mealLikes;
    if (map['mealLikes'] != null) {
      mealLikes = List<Map<String, String>>.from(map['mealLikes']);
    }
    var created = (map['created'] as Timestamp).toDate();
    var lastUpdated = (map['lastUpdated'] as Timestamp).toDate();
    var mealDate;
    if (map['mealDate'] != null) {
      mealDate = (map['mealDate'] as Timestamp).toDate();
    }

    return Group(
      joinCode: map['joinCode'],
      name: map['name'],
      members: members,
      admins: admins,
      created: created,
      lastUpdated: lastUpdated,
      lastUpdatedBy: map['lastUpdatedBy'],
      mealDate: mealDate,
      mealLikes: mealLikes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'joinCode': joinCode,
      'name': name,
      'members': members,
      'admins': admins,
      'created': created,
      'lastUpdated': lastUpdated,
      'lastUpdatedBy': lastUpdatedBy,
      'mealDate': mealDate,
      'mealLikes': mealLikes,
    };
  }

  // Getters
  String get id => _id;
  String get getJoinCode => joinCode;
  String get getName => name ?? '';
  List<String> get getMembers => members;
  List<String> get getAdmins => admins;
  DateTime get getCreated => created;
  DateTime get getLastUpdated => lastUpdated;
  String get getLastUpdatedBy => lastUpdatedBy;
  DateTime? get getMealDate => mealDate;
  List<MealLikes>? get getMealLikes => mealLikes;

  // Setters
  set id(String id) {
    _id = id;
  }

  set setName(String name) => this.name = name;
  set setMembers(List<String> members) => this.members = members;
  set setAdmins(List<String> admins) => this.admins = admins;
  set setLastUpdated(DateTime lastUpdated) => this.lastUpdated = lastUpdated;
  set setLastUpdatedBy(String lastUpdatedBy) =>
      this.lastUpdatedBy = lastUpdatedBy;
  set setMealDate(DateTime? mealDate) => this.mealDate = mealDate;
  set setMealLikes(List<MealLikes>? mealLikes) => this.mealLikes = mealLikes;

  // Methods

  Future<void> update() async {
    lastUpdated = DateTime.now();
    CurrentUser currentUser = CurrentUser();
    await currentUser.init();
    lastUpdatedBy = currentUser.user.id;
    FirebaseFirestore.instance.collection('groups').doc(_id).update(toMap());
  }

  void addMember(String uid) {
    members.add(uid);
    update();
  }

  void removeMember(String uid) {
    members.remove(uid);
    update();
  }

  void addAdmin(String uid) {
    CurrentUser currentUser = CurrentUser();
    if (admins.contains(currentUser.uid)) {
      admins.add(uid);
      update();
    }
  }

  void removeAdmin(String uid) {
    CurrentUser currentUser = CurrentUser();
    if (admins.contains(currentUser.uid)) {
      admins.remove(uid);
      update();
    }
  }

  void addMealLike(String mealId, String userId) {
    mealLikes ??= [
      MealLikes(mealId: mealId, userIds: [userId])
    ];
    mealLikes!.firstWhere(
      (element) => element.mealId == mealId,
      orElse: () {
        mealLikes!.add(MealLikes(mealId: mealId, userIds: [userId]));
        return MealLikes(mealId: mealId, userIds: [userId]);
      },
    ).addLike(userId);
    update();
  }

  void delete() {
    // Check if the current user is an admin of the group
    CurrentUser currentUser = CurrentUser();
    if (admins.contains(currentUser.uid)) {
      FirebaseFirestore.instance.collection('groups').doc(_id).delete();
    } else {
      // Raise error that the current user is not an admin
      throw Exception(
          'Current user (${currentUser.uid}) is not an admin of group ($_id)');
    }
  }

  Future<Meal>? checkForMatches() async {
    _logger.i('Checking for matches in group $_id');
    // Get the most recent group document
    var groupCollection = FirebaseFirestore.instance.collection('groups');
    var groupDoc = await groupCollection.doc(_id).get();

    if (!groupDoc.exists) return Future<Meal>.value(null);

    Group group = Group.fromMap(groupDoc.data()!);

    int nMembers = group.members.length;

    for (var mealLikes in group.mealLikes!) {
      if (mealLikes.userIds!.length == nMembers) {
        // Get the meal
        var mealDoc = await FirebaseFirestore.instance
            .collection('meals')
            .doc(mealLikes.mealId)
            .get();
        if (!mealDoc.exists) return Future<Meal>.value(null);
        Meal meal = Meal.fromDocument(mealDoc);
        _logger.i('Found match for meal ${meal.id}');
        _mealMatchController.add(meal);
        return Future<Meal>.value(meal);
      }
    }
    return Future<Meal>.value(null);
  }
}
