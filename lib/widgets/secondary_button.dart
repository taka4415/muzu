import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {
  final String text;
  final void Function() function;
  const SecondaryButton(
      {super.key, required this.text, required this.function});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          function();
        },
        style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.white,
            elevation: 3.0
            // side: BorderSide(
            //   color: Colors.black, //色
            //   width: 1, //太さ
            // ),
            ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.list_alt_rounded,
              color: Colors.black,
            ),
            const SizedBox(
              width: 4,
            ),
            Text(
              text,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
          ],
        ));
  }
}
