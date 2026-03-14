import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const AppText(this.text, {super.key, this.style});

  factory AppText.body(String text) {
    return AppText(text);
  }

  factory AppText.title(String text) {
    return AppText(
      text,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Text(text, style: style);
  }
}
