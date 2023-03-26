import 'package:logger/logger.dart';

class MealLikes {
  final Logger _logger = Logger();
  final String mealId;
  final List<String>? userIds;
  MealLikes({
    required this.mealId,
    this.userIds,
  });

  void addLike(String userId) {
    if (userIds == null) return;
    if (userIds!.contains(userId)) {
      _logger.w("User $userId already liked $mealId");
      return;
    }
    userIds!.add(userId);
    _logger.d("Added like for $mealId from $userId");
  }

  static fromJson(x) {
    return MealLikes(
      mealId: x['mealId'],
      userIds: x['userIds'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'mealId': mealId,
      'userIds': userIds,
    };
  }

  factory MealLikes.fromMap(x) {
    var userIds = List<String>.from(x['userIds']);
    return MealLikes(
      mealId: x['mealId'],
      userIds: userIds,
    );
  }
}
