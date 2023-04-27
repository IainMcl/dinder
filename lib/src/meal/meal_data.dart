abstract class MealData{
  Future<Meal?> getMealById(String mealId);
  Future<Meal> createMeal(Meal meal);
  Future<void> updateMeal(Meal meal);
  Future<void> deleteMeal(String mealId);
}
