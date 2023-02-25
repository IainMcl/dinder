class MealLikes {
  final String mealId;
  final List<String>? userIds;
  MealLikes({
    required this.mealId,
    this.userIds,
  });

  void addLike(String userId) {
    if (userIds == null) return;

    userIds!.add(userId);
  }
}
