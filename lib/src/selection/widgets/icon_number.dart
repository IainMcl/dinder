import 'package:flutter/material.dart';

class IconNumber extends StatelessWidget {
  final IconData icon;
  final String number;
  final String text;

  const IconNumber(
      {super.key,
      required this.icon,
      required this.number,
      required this.text});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: "Cooking Time",
      child: Row(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 5),
          Text(number, style: const TextStyle(color: Colors.white)),
          const SizedBox(width: 5),
        ],
      ),
    );
  }
}
