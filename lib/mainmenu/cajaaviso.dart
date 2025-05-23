import 'package:flutter/material.dart';

class CajaAvisoEstiloBoton extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final double fontSize;
  final FontWeight fontWeight;
  final List<BoxShadow>? boxShadow; // Propiedad opcional para la sombra

  const CajaAvisoEstiloBoton({
    super.key,
    required this.text,
    this.backgroundColor = const Color(
      0xFF6B45A8,
    ), // Color de fondo por defecto
    this.textColor = Colors.white, // Color de texto por defecto
    this.fontSize = 18, // Tamaño de fuente por defecto
    this.fontWeight = FontWeight.bold, // Grosor de fuente por defecto
    this.boxShadow, // Por defecto, usará una sombra interna o ninguna si es null
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300, // Ancho fijo, puedes hacerlo configurable o usar Constraints
      height: 50, // Altura fija
      alignment: Alignment.center, // Centra el texto vertical y horizontalmente
      decoration: BoxDecoration(
        color: backgroundColor, // Color de fondo de la "caja"
        borderRadius: BorderRadius.circular(25), // Bordes redondeados
        boxShadow:
            boxShadow ??
            [
              // Si no se pasa una sombra, usa esta por defecto
              BoxShadow(
                color: Color.fromRGBO(
                  0,
                  0,
                  0,
                  0.15,
                ), // Color de la sombra (ligeramente transparente)
                offset: Offset(
                  0,
                  6,
                ), // Desplazamiento de la sombra (horizontal, vertical)
                blurRadius: 8, // Qué tan difuminada está la sombra
                spreadRadius:
                    -4, // Qué tan expandida o contraída está la sombra
              ),
            ],
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: textColor,
          fontSize: fontSize,
          fontWeight: fontWeight,
          fontFamily: 'Raleway', // Si usas una fuente específica
        ),
      ),
    );
  }
}
