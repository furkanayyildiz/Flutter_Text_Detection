import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool obscureText;
  final IconData icon;

  const CustomTextField({
    Key? key,
    required this.hintText,
    required this.controller,
    this.obscureText = false,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: TextField(
        obscureText: obscureText,
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.indigo),
          border: InputBorder.none,
          prefixIcon: Icon(
            icon,
            color: Colors.indigo,
          ),
        ),
      ),
    );
  }
}
