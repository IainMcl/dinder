import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dinder/src/meal/data/firebase_meal_data.dart';
import 'package:dinder/src/meal/data/meal_data.dart';
import 'package:dinder/src/meal/models/ingredient.dart';
import 'package:logger/logger.dart';

class Meal {
  late String _id;
  String title;
  String? description;
  String? image;
  List<Ingredient> ingredients = [];
  int cookingTime = 0;
  int prepTime = 0;
  int servings = 0;
  List<String> instructions;

  Meal(
      {required this.title,
      this.description,
      this.image,
      this.ingredients = const [],
      this.cookingTime = 0,
      this.prepTime = 0,
      this.servings = 0,
      required this.instructions});

  // getters
  String get id => _id;
  String get getTitle => title;
  String? get getDescription => description;
  String? get getImage => image;
  List<Ingredient> get getIngredients => ingredients;
  int get getCookingTime => cookingTime;
  int get getPrepTime => prepTime;
  int get getServings => servings;
  List<String> get getInstructions => instructions;

  // setters
  set id(String id) => _id = id;

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      title: json['title'],
      description: json['description'],
      image: json['image'],
      ingredients: json['ingredients'],
      cookingTime: json['cookingTime'],
      prepTime: json['prepTime'],
      servings: json['servings'],
      instructions: json['instructions'],
    );
  }

  factory Meal.fromDocument(DocumentSnapshot doc) {
    var ingredients = doc.get("ingredients") as List<dynamic>;
    List<Ingredient> ingredientsList = [];
    for (var element in ingredients) {
      ingredientsList.add(Ingredient.fromMap(element));
    }

    var instructions = doc.get("instructions") as List<dynamic>;
    List<String> instructionsList = [];
    for (var element in instructions) {
      instructionsList.add(element);
    }

    Meal meal = Meal(
      title: doc.get("title"),
      description: doc.get("description"),
      image: doc.get("image"),
      ingredients: ingredientsList,
      cookingTime: doc.get("cookingTime"),
      prepTime: doc.get("prepTime"),
      servings: doc.get("servings"),
      instructions: instructionsList,
    );

    meal.id = doc.id;
    return meal;
  }

  static Future<List<Meal>> getMeals([List<String>? userLikedMeals]) async {
    userLikedMeals ??= [];
    MealData mealData = FirebaseMealData();
    List<Meal> meals = await mealData.getMeals(userLikedMeals);

    // TODO: Remove this when we have more meals
    // Repeat the meals to make sure we have enough 100 times
    // meals = List.generate(100, (index) => meals)
    //     .expand((element) => element)
    //     .toList();
    return meals;
  }
}
