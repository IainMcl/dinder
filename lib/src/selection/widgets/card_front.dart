import 'dart:async';

import 'package:dinder/src/selection/models/meal.dart';
import 'package:flutter/material.dart';

class CardFront extends StatelessWidget {
  final Meal card;

  const CardFront({Key? key, required this.card}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.network(
          'https://images.pexels.com/photos/376464/pexels-photo-376464.jpeg',
          fit: BoxFit.cover,
        ),
        Positioned(
          bottom: 0,
          left: 0,
          child: Container(
            padding: EdgeInsets.all(5),
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
                const SizedBox(height: 10),
                Text(
                  card.description ?? "",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
