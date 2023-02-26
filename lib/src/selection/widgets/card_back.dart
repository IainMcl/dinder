import 'dart:async';

import 'package:dinder/src/selection/models/meal.dart';
import 'package:dinder/src/selection/widgets/icon_number.dart';
import 'package:flutter/material.dart';

class CardBack extends StatelessWidget {
  final Meal card;
  final Alignment beginAlignment;
  final Alignment endAlignment;
  final Color beginColor;
  final Color endColor;

  const CardBack(
      {Key? key,
      required this.card,
      required this.beginAlignment,
      required this.endAlignment,
      required this.beginColor,
      required this.endColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // Some nice linear gradient between the three colors
      decoration: BoxDecoration(
          gradient: LinearGradient(
        begin: beginAlignment,
        end: endAlignment,
        colors: [
          beginColor,
          endColor,
        ],
      )),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Container(
            color: Colors.white,
            child: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                height: 500,
                child: Column(
                  children: [
                    // image
                    Expanded(
                      flex: 1,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          // image
                          FadeInImage(
                              image: NetworkImage(card.image ?? ""),
                              placeholder: const AssetImage(
                                  "assets/images/knifeAndFork.png"),
                              fit: BoxFit.cover),
                          // prep time and cooking time as icon then number in top right
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8, right: 5),
                              child: Row(
                                children: [
                                  IconNumber(
                                    icon: Icons.timer,
                                    number: card.prepTime.toString(),
                                    text: "Prep Time",
                                  ),
                                  // Servings
                                  IconNumber(
                                      icon: Icons.person,
                                      number: card.servings.toString(),
                                      text: "Servings"),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              color: Colors.black54,
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    card.title,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // title
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        color: Colors.white,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Ingredients
                            const Text(
                              "Ingredients",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            // Ingredients List
                            ListView(
                              shrinkWrap: true,
                              children: card.ingredients
                                  .map((ingredient) => Text(
                                        ingredient.name,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                      ))
                                  .toList(),
                            ),
                            // Directions
                            const Text(
                              "Directions",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            // Directions numbered List in the form 1. Do this
                            ListView(
                              shrinkWrap: true,
                              children: card.instructions
                                  .asMap()
                                  .entries
                                  .map((e) => Text(
                                        "${e.key + 1}. ${e.value}",
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                      ))
                                  .toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
