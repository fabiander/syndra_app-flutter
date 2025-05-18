import 'package:flutter/material.dart';


Widget cajastexto(String hint, {IconData? icon}) {
  return TextField(
    style: TextStyle(
      fontFamily: 'Raleway',
      fontWeight: FontWeight.w500, // Medium
      fontSize: 18,
      color: Color.fromRGBO(33, 78, 62, 1.0), // Color del texto ingresado
    ),

    decoration: InputDecoration(
      prefixIcon:
          icon != null
              ? Icon(icon, color: Color.fromRGBO(33, 78, 62, 1.0))
              : null, // Si no hay icono, no se muestra nada// Icono verde
      hintText: hint,
      hintStyle: TextStyle(
        color: Color.fromRGBO(33, 78, 62, 1.0), // Color del hint (verde)
        fontFamily: 'Raleway',
        fontWeight: FontWeight.w500,
        fontSize: 18,
      ),
      border: UnderlineInputBorder(),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.teal), // Color de la línea
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.teal, width: 2),
      ),
    ),
  );
}
