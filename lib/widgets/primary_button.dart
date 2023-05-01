import 'package:flutter/material.dart';
import 'package:englishapp/utils/colors.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final void Function() function;
  const PrimaryButton({super.key, required this.text, required this.function});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          function();
        },
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: primaryColor,
          elevation: 3.0,
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 18),
        ));
  }
}
