import 'package:flutter/material.dart';

class CustomGestureDetector extends StatelessWidget {
  final String title;
  final Function() onTap;
  const CustomGestureDetector(
      {super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.white,
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.indigo,
                fontSize: 25,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
