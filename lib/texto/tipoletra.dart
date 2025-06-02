// lib/styles/text_styles.dart
import 'package:flutter/material.dart';

const TextStyle menuSectionTitleStyle = TextStyle(
  fontFamily: 'Raleway',
  color: Color.fromRGBO(
    33,
    78,
    62,
    1.0,
  ), // Este es el color verde oscuro que quieres
  fontSize: 18,
  fontWeight: FontWeight.w500,
);


// Puedes añadir más estilos aquí si los necesitas en el futuro
const TextStyle counterLabelStyle = TextStyle(
  fontFamily: 'Raleway', // Mismo Raleway
  color: Colors.white, // El color de los números y etiquetas de tiempo es blanco
  fontSize: 18,
  fontWeight: FontWeight.w500, // O el peso que prefieras para los números
);


const TextStyle counterTitleStyle = TextStyle(
  fontFamily: 'Raleway', // Mismo Raleway
  fontSize: 22,
  fontWeight: FontWeight.bold,
  color: Color.fromRGBO(
    33,
    78,
    62,
    1.0,
  ), // El color del título "He estado libre durante"
);
