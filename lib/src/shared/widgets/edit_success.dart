import 'package:flutter/material.dart';

class EditSuccess extends StatefulWidget {
  EditSuccess({Key? key}) : super(key: key);

  @override
  State<EditSuccess> createState() => EditSuccessState();
}

class EditSuccessState extends State<EditSuccess> {
  var _currIndex = 1;

  void toggleState() {
    setState(() {
      _currIndex = _currIndex == 0 ? 1 : 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, anim) => RotationTransition(
        turns: child.key == ValueKey('icon1')
            ? Tween<double>(begin: 1, end: 0.75).animate(anim)
            : Tween<double>(begin: 0.75, end: 1).animate(anim),
        child: FadeTransition(opacity: anim, child: child),
      ),
      child: _currIndex == 0
          ? const Icon(Icons.edit, key: ValueKey('icon1'), color: Colors.white)
          : const Icon(
              Icons.check,
              key: ValueKey('icon2'),
              color: Colors.white,
            ),
    );
  }
}
