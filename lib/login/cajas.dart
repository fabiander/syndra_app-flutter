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
        //  el campo   qu  recibe  el texto de entrada
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(
          fontFamily: 'Raleway',
          fontWeight: FontWeight.w500,
          fontSize: 18,
          color: Color.fromRGBO(33, 78, 62, 1.0),
        ),

        decoration: InputDecoration(
          // el campo dondo se muestra el icono y el texto en verde
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

          border: const UnderlineInputBorder(), //  linea de abajo del campo
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.teal),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.teal, width: 2),
          ),

          suffixIcon:
              isPassword //  si el campo es de contraseña, se muestra el icono de ojo
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
