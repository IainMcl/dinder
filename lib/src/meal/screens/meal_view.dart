import 'package:dinder/src/meal/models/meal.dart';
import 'package:flutter/material.dart';

class MealView extends StatefulWidget {
  const MealView({Key? key, required this.meal}) : super(key: key);
  final Meal meal;

  @override
  _MealViewState createState() => _MealViewState();
}

class _MealViewState extends State<MealView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.meal.title),
      ),
      body: Center(
        child: Text(widget.meal.title),
      ),
    );
  }
}
