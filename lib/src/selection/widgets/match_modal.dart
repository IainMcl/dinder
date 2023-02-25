import 'package:dinder/src/selection/models/meal.dart';
import 'package:flutter/material.dart';

class MatchModal extends StatelessWidget {
  late Meal meal;
  MatchModal({Key? key, required Meal meal}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Text("Match Modal with ${meal.title}"),
    );
  }
}
