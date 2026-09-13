import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final IconData icon;
  final String hint;
  final bool obscure;
  final TextEditingController? controller;
  final TextInputType keyboardType;

  const CustomTextField({
    super.key,
    required this.icon,
    required this.hint,
    this.controller,
    this.obscure = false,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      cursorColor: Colors.white,
      decoration: InputDecoration(
        filled: false,
        prefixIcon: Icon(icon, color: Colors.white70),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white60),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white54),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }
}