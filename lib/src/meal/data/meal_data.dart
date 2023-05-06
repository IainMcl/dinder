import 'package:dinder/src/meal/models/meal.dart';

abstract class MealData{
  Future<Meal?> getMealById(String mealId);
  Future<Meal> createMeal(Meal meal);
  Future<void> updateMeal(Meal meal);
  Future<void> deleteMeal(String mealId);
  Future<List<Meal>> getMeals(List<String>? excludeMeals);
}
