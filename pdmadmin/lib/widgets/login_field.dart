import 'package:flutter/material.dart';

class LoginField extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final Widget? suffixIcon;

  const LoginField({
    Key? key,
    required this.hintText,
    this.obscureText = false,
    this.suffixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 400,
      ),
      child: TextFormField(
        obscureText: obscureText,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(16),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.grey, // Adjust the color as needed
              width: 2,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.blue, // Adjust the color as needed
              width: 2,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          hintText: hintText,
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}
