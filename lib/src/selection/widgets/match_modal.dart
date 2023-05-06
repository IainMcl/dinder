import 'package:dinder/src/meal/models/meal.dart';
import 'package:dinder/src/meal/screens/meal_view.dart';
import 'package:flutter/material.dart';

class MatchModal extends StatelessWidget {
  const MatchModal({Key? key, required this.meal}) : super(key: key);
  final Meal meal;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Matched meal"),
      content: Text(meal.title),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MealView(meal: meal)));
            },
            child: const Text("View match")),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Close"),
        ),
      ],
    );
  }
}
