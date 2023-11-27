import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final String title;
  final Function() onPressed;
  const CustomElevatedButton({
    super.key,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.indigo,
        textStyle: const TextStyle(fontSize: 20, color: Colors.white),
      ),
      onPressed: onPressed,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          color: Colors.white,
        ),
      ),
    );
  }
}
