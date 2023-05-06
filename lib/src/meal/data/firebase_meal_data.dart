import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dinder/src/meal/data/meal_data.dart';
import 'package:dinder/src/meal/models/meal.dart';
import 'package:logger/logger.dart';

class FirebaseMealData implements MealData {
  final Logger _logger = Logger();

  @override
  Future<Meal> createMeal(Meal meal) {
    // TODO: implement createMeal
    throw UnimplementedError();
  }

  @override
  Future<void> deleteMeal(String mealId) {
    // TODO: implement deleteMeal
    throw UnimplementedError();
  }

  @override
  Future<Meal?> getMealById(String mealId) async {
    var mealDoc = await FirebaseFirestore.instance
        .collection('meals')
        .doc(mealId)
        .get()
        .onError((error, stackTrace) {
      _logger.e("Error getting meal $mealId: $error");
      return Future<DocumentSnapshot<Map<String, dynamic>>>.value(null);
    });

    if (!mealDoc.exists) return null;
    Meal meal = Meal.fromDocument(mealDoc);
    return meal;
  }

  @override
  Future<void> updateMeal(Meal meal) {
    // TODO: implement updateMeal
    throw UnimplementedError();
  }

  @override
  Future<List<Meal>> getMeals(List<String>? excludeMeals) async{
    var mealDocs = await FirebaseFirestore.instance
      .collection("meals")
    .where(
      FieldPath.documentId,
      whereNotIn: excludeMeals
    )
    .get()
    .catchError((error) => {
      _logger.e("Error retreiving meals: $error")
    });

    var meals = mealDocs.docs.map((e) => Meal.fromDocument(e)).toList();
    return meals;
  }
}
