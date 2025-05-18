// botones_base/boton_fantasma.dart
import 'package:flutter/material.dart';

class BotonFantasma extends StatelessWidget {
  final String label;
  final Color textColor;
  final Color borderColor;
  final bool withShadow;
  final VoidCallback onPressed;

  const BotonFantasma({
    super.key,
    required this.label,
    this.textColor = const Color.fromRGBO(33, 78, 62, 1.0),
    this.borderColor = const Color.fromRGBO(255, 255, 255, 1.0),
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
                ]
                : [],
      ),




      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        onPressed: onPressed,
        child: Text(label, style: TextStyle(color: textColor)),
      ),
    );
  }
}

