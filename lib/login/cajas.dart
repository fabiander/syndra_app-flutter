import 'package:flutter/material.dart';

Widget cajastexto(
  String hint, {
  IconData? icon,
  required TextEditingController controller,
  bool isPassword = false,
}) {
  return StatefulBuilder(
    builder: (context, setState) {
      bool obscureText = isPassword;

      return TextField(
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(
          fontFamily: 'Raleway',
          fontWeight: FontWeight.w500,
          fontSize: 18,
          color: Color.fromRGBO(33, 78, 62, 1.0),
        ),
        decoration: InputDecoration(
          prefixIcon:
              icon != null
                  ? Icon(icon, color: Color.fromRGBO(33, 78, 62, 1.0))
                  : null,
          hintText: hint,
          hintStyle: const TextStyle(
            color: Color.fromRGBO(33, 78, 62, 1.0),
            fontFamily: 'Raleway',
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
          border: const UnderlineInputBorder(),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.teal),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.teal, width: 2),
          ),
          suffixIcon:
              isPassword
                  ? IconButton(
                    icon: Icon(
                      obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Color.fromRGBO(33, 78, 62, 1.0),
                    ),
                    onPressed: () {
                      setState(() {
                        obscureText = !obscureText;
                      });
                    },
                  )
                  : null,
        ),
      );
    },
  );
}
