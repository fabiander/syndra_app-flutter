// botones_base/boton_fantasma.dart
import 'package:flutter/material.dart';

class BotonFantasma extends StatelessWidget {
  final String label;
  final Color textColor;
  final Color borderColor;
  final Color backgroundColor;
  final bool withShadow;
  final VoidCallback onPressed;

  const BotonFantasma({
    super.key,
    required this.label,
    this.textColor = const Color.fromRGBO(33, 78, 62, 1.0),
    this.borderColor = const Color.fromRGBO(255, 255, 255, 1.0),
    this.backgroundColor = Colors.transparent,
    this.withShadow = false,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 50,

      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: borderColor, width: 2),
        boxShadow:[
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.15),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                    spreadRadius: -4,
                  ),
                ],
      ),




      child: TextButton(
        style: ButtonStyle(

          backgroundColor: WidgetStateProperty.resolveWith<Color>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.pressed)) {
                return const Color.fromRGBO(33, 78, 62, 1.0); // Color al presionar
              }
              return backgroundColor;
            },
          ),

          foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
            if (states.contains(WidgetState.pressed)) {
              return Colors.white; // texto cuando se presiona
            }
            return textColor; // texto por defecto
          }),

          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
        ),



        onPressed: onPressed,
        
        child: Text(
          label,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            fontFamily: 'Raleway',
          ),
        ),
      ),
    );
  }
}

