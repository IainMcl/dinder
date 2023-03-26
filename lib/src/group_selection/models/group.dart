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
      mealLikes: json['mealLikes'] != null
          ? List<MealLikes>.from(
              json['mealLikes'].map((x) => MealLikes.fromJson(x)))
          : null,
    );
  }

  static Group fromMap(Map<String, dynamic> map) {
    var members = List<String>.from(map['members']);
    var admins = List<String>.from(map['admins']);
    List<MealLikes> mealLikes;
    if (map['mealLikes'] != null) {
      mealLikes = List<MealLikes>.from(
          map['mealLikes'].map((x) => MealLikes.fromMap(x)));
    } else {
      mealLikes = [];
    }
    var created = (map['created'] as Timestamp).toDate();
    var lastUpdated = (map['lastUpdated'] as Timestamp).toDate();
    DateTime mealDate;
    if (map['mealDate'] != null) {
      mealDate = (map['mealDate'] as Timestamp).toDate();
    } else {
      mealDate = DateTime.now();
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
    // convert mealLikes to mappable format
    List<Map<String, dynamic>> mealLikesMappable = [];
    if (mealLikes != null) {
      mealLikesMappable = mealLikes!.map((x) => x.toMap()).toList();
    }

    var ret = {
      'joinCode': joinCode,
      'name': name,
      'members': members,
      'admins': admins,
      'created': created,
      'lastUpdated': lastUpdated,
      'lastUpdatedBy': lastUpdatedBy,
      'mealDate': mealDate,
      'mealLikes': mealLikesMappable
    };
    return ret;
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

  Future<void> update(CurrentUser currentUser) async {
    lastUpdated = DateTime.now();
    lastUpdatedBy = currentUser.user.id;
    await FirebaseFirestore.instance
        .collection('groups')
        .doc(_id)
        .update(toMap())
        .onError((error, stackTrace) =>
            {_logger.e("Error updating group: $error : $stackTrace")});
    _logger.d("Updated group $id");
  }

  void addMember(String uid, CurrentUser currentUser) {
    _logger.d("Adding member $uid to group $id");
    members.add(uid);
    update(currentUser);
    _logger.d("Added member $uid to group $id");
  }

  void removeMember(String uid, CurrentUser currentUser) {
    _logger.d("Removing member $uid from group $id");
    members.remove(uid);
    // If the user is an admin, remove them from the admins list
    if (admins.contains(uid)) {
      admins.remove(uid);
    }
    update(currentUser);
    _logger.d("Removed member $uid from group $id");
  }

  void addAdmin(String uid, CurrentUser currentUser) {
    _logger.d("Adding admin $uid to group $id");
    CurrentUser currentUser = CurrentUser();
    if (admins.contains(currentUser.uid)) {
      admins.add(uid);
      update(currentUser);
      _logger.d("Added admin $uid to group $id");
    } else {
      _logger.e(
          "User ${currentUser.uid} is not an admin of group $id and cannot add admins");
    }
  }

  void removeAdmin(String uid, CurrentUser currentUser) {
    _logger.d("Removing admin $uid from group $id");
    CurrentUser currentUser = CurrentUser();
    if (admins.contains(currentUser.uid)) {
      admins.remove(uid);
      update(currentUser);
      _logger.d("Removed admin $uid from group $id");
    } else {
      _logger.e(
          "User ${currentUser.uid} is not an admin of group $id and cannot remove admins");
    }
  }

  void addMealLike(String mealId, String userId, CurrentUser currentUser) {
    _logger.d("Adding like for meal $mealId");
    mealLikes ??= [
      MealLikes(mealId: mealId, userIds: [userId])
    ];
    mealLikes!.firstWhere(
      (element) => element.mealId == mealId,
      orElse: () {
        _logger.d("Meal has no likes yet. Adding new MealLike");
        mealLikes!.add(MealLikes(mealId: mealId, userIds: [userId]));
        return MealLikes(mealId: mealId, userIds: [userId]);
      },
    ).addLike(userId);
    update(currentUser);
  }

  Future<void> delete() async {
    _logger.d("Deleting group $id");
    // Check if the current user is an admin of the group
    CurrentUser currentUser = CurrentUser();
    await currentUser.init();
    if (admins.contains(currentUser.uid)) {
      FirebaseFirestore.instance
          .collection('groups')
          .doc(_id)
          .delete()
          .catchError((error) {
        _logger.e("Error deleting group $id: $error");
      });
      _logger.d("Deleted group $id");
    } else {
      // Raise error that the current user is not an admin
      _logger
          .e("Current user (${currentUser.uid}) is not an admin of group $_id");
      throw Exception(
          'Current user (${currentUser.uid}) is not an admin of group ($_id)');
    }
  }

  Future<Meal?> checkForMatches() async {
    _logger.i('Checking for matches in group $_id');
    // Get the most recent group document
    var groupCollection = FirebaseFirestore.instance.collection('groups');
    var groupDoc = await groupCollection.doc(_id).get();

    if (!groupDoc.exists) return null;

    Group group = Group.fromMap(groupDoc.data()!);

    if (group.mealLikes == null) return null;

    int nMembers = group.members.length;

    for (var mealLikes in group.mealLikes!) {
      if (mealLikes.userIds!.length == nMembers) {
        // Get the meal
        var mealDoc = await FirebaseFirestore.instance
            .collection('meals')
            .doc(mealLikes.mealId)
            .get()
            .onError((error, stackTrace) {
          _logger.e("Error getting meal ${mealLikes.mealId}: $error");
          return Future<DocumentSnapshot<Map<String, dynamic>>>.value(null);
        });

        if (!mealDoc.exists) return null;
        Meal meal = Meal.fromDocument(mealDoc);
        _logger.i('Found match for meal ${meal.id}');
        _mealMatchController.add(meal);
        _logger.i(
            "Match found for meal ${meal.id}. Updated mealMatchController stream");
        return Future<Meal>.value(meal);
      }
    }
    return null;
  }

  void resetGroupMeal(CurrentUser currentUser) {
    _logger.d("Resetting group meal for group $id");
    mealDate = null;
    mealLikes = null;
    update(currentUser);
    _logger.d("Reset group meal for group $id");
  }
}
