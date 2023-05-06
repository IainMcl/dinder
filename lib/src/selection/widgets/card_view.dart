import 'dart:math';

import 'package:dinder/src/meal/models/meal.dart';
import 'package:dinder/src/selection/widgets/card_back.dart';
import 'package:dinder/src/selection/widgets/card_front.dart';
import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';

class MealCardView extends StatefulWidget {
  final Meal card;
  MealCardView({required this.card});

  @override
  _MealCardViewState createState() => _MealCardViewState();
}

class _MealCardViewState extends State<MealCardView> {
  Alignment getGradientAlignment() {
    // Random Aligmnent
    var random = new Random();

    List<Alignment> alignments = [
      Alignment.topLeft,
      Alignment.topCenter,
      Alignment.topRight,
      Alignment.centerLeft,
      Alignment.center,
      Alignment.centerRight,
      Alignment.bottomLeft,
      Alignment.bottomCenter,
      Alignment.bottomRight,
    ];

    return alignments[random.nextInt(alignments.length)];
  }

  Color getRandomColor() {
    // Random Color
    var random = new Random();

    List<Color> colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.yellow,
      Colors.purple,
      Colors.orange,
      Colors.pink,
      Colors.grey,
    ];

    return colors[random.nextInt(colors.length)];
  }

  late Alignment beginAlignment;
  late Alignment endAlignment;
  late Color beginColor;
  late Color endColor;

  @override
  void initState() {
    super.initState();
    beginAlignment = getGradientAlignment();
    endAlignment = getGradientAlignment();
    beginColor = getRandomColor();
    endColor = getRandomColor();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      // rounded corners

      borderRadius: BorderRadius.circular(5),
      child: FlipCard(
        fill: Fill
            .fillBack, // Fill the back side of the card to make in the same size as the front.
        direction: FlipDirection.VERTICAL, // default
        side: CardSide.FRONT, // The side to initially display.
        front: CardFront(card: widget.card),
        // back: Container()
        back: CardBack(
            card: widget.card,
            beginAlignment: beginAlignment,
            endAlignment: endAlignment,
            beginColor: beginColor,
            endColor: endColor),
      ),
    );
  }
}
