import 'package:dinder/src/group_selection/models/group.dart';
import 'package:dinder/src/selection/models/ingredient.dart';
import 'package:dinder/src/selection/models/meal.dart';
import 'package:dinder/src/selection/services/selection_service.dart';
import 'package:dinder/src/selection/widgets/card_view.dart';
import 'package:dinder/src/selection/widgets/match_modal.dart';
import 'package:dinder/src/shared/widgets/three_dots_menu.dart';
import 'package:dinder/src/user/models/current_user.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:swipeable_card_stack/swipeable_card_stack.dart';

class Selection extends StatefulWidget {
  const Selection({Key? key, required this.group}) : super(key: key);
  final Group group;

  @override
  _SelectionState createState() => _SelectionState();
}

class _SelectionState extends State<Selection> {
  final Logger _logger = Logger();
  //create a SwipeableCardSectionController
  final SwipeableCardSectionController _cardController =
      SwipeableCardSectionController();
  late SelectionService _selectionService;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: Dispose od meal match stream
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CurrentUser currentUser = Provider.of<CurrentUser>(context);
    final bool currentUserIsGroupAdmin =
        widget.group.admins.contains(currentUser.uid);
    _selectionService = SelectionService(widget.group, currentUser);
    _selectionService.group.checkForMatches();
    void listenToMatchStream() {
      _selectionService.group.mealMatchStream.listen((match) {
        _logger.d("Matched meal: ${match.title}");
        // Show match modal with the matched meal

        showDialog(
            context: context, builder: (context) => MatchModal(meal: match));
      });
    }

    listenToMatchStream();

    List<Meal> meals = [];

    final Meal emptyMeal = Meal(
      title: "No more meals",
      description: "No more meals",
      image: "No more meals",
      ingredients: List<Ingredient>.empty(),
      cookingTime: 0,
      prepTime: 0,
      servings: 0,
      instructions: List<String>.empty(),
    );

    Future<List<Meal>> getNextMeals(int i) async {
      List<Meal> newMeals = await _selectionService.getMeals(i);
      if (newMeals.isEmpty) {
        newMeals.add(emptyMeal);
      }
      meals.addAll(newMeals);
      return Future.value(newMeals);
    }

    void removeMeal(Meal meal) {
      meals.remove(meal);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.group.name ?? "Meal selection"),
        actions: const [
          ThreeDotsMenu(),
        ],
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FutureBuilder(
            future: getNextMeals(3),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SwipeableCardsSection(
                  cardController: _cardController,
                  context: context,
                  cardWidthTopMul: 0.95,
                  cardWidthMiddleMul: 0.90,
                  cardWidthBottomMul: 0.85,
                  cardHeightTopMul: 0.70,
                  cardHeightMiddleMul: 0.65,
                  cardHeightBottomMul: 0.60,
                  //add the first 3 cards (widgets)
                  items: () {
                    List<MealCardView> MealCardViews = [];
                    if (meals.length < 3) {
                      for (var meal in meals) {
                        MealCardViews.add(MealCardView(
                          card: meal,
                        ));
                      }
                      if (meals.isEmpty) {
                        MealCardViews.add(MealCardView(card: emptyMeal));
                      }
                      return MealCardViews;
                    }
                    for (int i = 0; i < 3; i++) {
                      MealCardViews.add(MealCardView(
                        card: meals[i],
                      ));
                    }
                    return MealCardViews;
                  }(),

                  //Get card swipe event callbacks
                  onCardSwiped: (dir, index, widget) {
                    // remove the swiped card from the list
                    removeMeal(widget.card);
                    //Add the next card using _cardController
                    getNextMeals(1);
                    // If there are no more meals, add the empty meal
                    if (meals.isEmpty) {
                      meals.add(emptyMeal);
                    } else {
                      _cardController.addItem(
                        // Get the next card from the list
                        MealCardView(
                          card: meals.last,
                        ),
                      );
                    }

                    //Take action on the swiped widget based on the direction of swipe
                    _selectionService.handleSwipe(dir, widget);
                    //Return false to not animate cards
                  },
                  //
                  enableSwipeUp: false,
                  enableSwipeDown: false,
                );
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              FloatingActionButton(
                heroTag: "leftSwipe",
                backgroundColor: Colors.white,
                onPressed: () {
                  //Swipe to left
                  _cardController.triggerSwipeLeft();
                },
                child: const Icon(Icons.close, color: Colors.redAccent),
              ),
              // FloatingActionButton(
              //   heroTag: "undo",
              //   backgroundColor: Colors.white,
              //   onPressed: () {},
              //   child: const Icon(Icons.undo, color: Colors.yellow),
              // ),
              FloatingActionButton(
                heroTag: "rightSwipe",
                backgroundColor: Colors.white,
                onPressed: () {
                  //Swipe to right
                  _cardController.triggerSwipeRight();
                },
                child: const Icon(
                  Icons.favorite,
                  color: Colors.greenAccent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 45),
        ],
      ),
    );
  }
}
