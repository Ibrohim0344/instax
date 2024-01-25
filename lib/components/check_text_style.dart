import 'package:flutter/material.dart';

class CheckText extends StatelessWidget {
  final String text;
  final bool contains;

  const CheckText({
    required this.text,
    required this.contains,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: contains
            ? Colors.green
            : Theme.of(context).colorScheme.onBackground,
      ),
    );
  }
}
