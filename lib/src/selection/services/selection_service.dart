import 'package:dinder/src/group_selection/models/group.dart';
import 'package:dinder/src/meal/models/meal.dart';
import 'package:dinder/src/selection/widgets/card_view.dart';
import 'package:dinder/src/user/models/current_user.dart';
import 'package:logger/logger.dart';
import 'package:swipeable_card_stack/swipe_controller.dart';

class SelectionService {
  final _logger = Logger();
  late Group group;
  final CurrentUser _currentUser;
  List<Meal> meals = [];
  bool fetchedMeals = false;
  int nMealsShown = 0;

  SelectionService(this.group, this._currentUser);

  Future<void> init() async {
    meals = await Meal.getMeals(getCurrentUserMealLikes());
    fetchedMeals = true;
    // order meals randomly
    meals.shuffle();
  }

  void handleSwipe(Direction dir, MealCardView card) {
    group.checkForMatches();
    switch (dir) {
      case Direction.left:
        addDislike(card.card);
        break;
      case Direction.right:
        addLike(card.card);
        break;
      case Direction.up:
        print("Up");
        break;
      case Direction.down:
        print("Down");
        break;
    }
  }

  void addDislike(Meal card) async {
    _logger.i("Add dislike $card");
    // add to firestor
  }

  Future<void> addLike(Meal card) async {
    _logger.i("Add like $card");
    // if the current user hasn't been initialized yet, await the initialization
    if (!_currentUser.initialized) {
      await _currentUser.init();
    }
    group.addMealLike(card.id, _currentUser.user.id, _currentUser);
  }

  List<String> getCurrentUserMealLikes() {
    List<String> currentUserMealLikes = [];
    if (group.mealLikes != null) {
      // Current user meal likes is a list of meal ids that the current user has liked
      for (var mealLike in group.mealLikes!) {
        if (mealLike.userIds!.contains(_currentUser.user.id)) {
          currentUserMealLikes.add(mealLike.mealId);
        }
      }
    }
    return currentUserMealLikes;
  }

  Future<List<Meal>> getMeals(int i) async {
    _logger.d("Getting $i meals");
    if (!fetchedMeals) {
      _logger.i(
          "Meals have not currently been fetched, fetching now from getMeals.");
      meals = await Meal.getMeals(getCurrentUserMealLikes());
      fetchedMeals = true;
    }
    int endIndex = nMealsShown + i;
    // Get the next i meals from the list
    if (meals.length < nMealsShown + i) {
      _logger.i("Not enough meals to show, showing all remaining meals.");
      endIndex = meals.length;
    }
    List<Meal> nextMeals = meals.sublist(nMealsShown, endIndex);
    nMealsShown = endIndex;
    return nextMeals;
  }
}
