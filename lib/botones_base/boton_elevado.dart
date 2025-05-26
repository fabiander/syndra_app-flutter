import 'package:flutter/material.dart';

class BotonElevado extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final double elevation;
  final VoidCallback onPressed;
  final List<BoxShadow>? sombraPersonalizada;
  final double width;
  final double height;

  const BotonElevado({
    super.key,
    required this.label,
    this.backgroundColor = const Color.fromRGBO(255, 255, 255, 1.0),
    this.textColor = const Color.fromRGBO(33, 78, 62, 1.0),
    this.elevation = 4.0,
    required this.onPressed,
    this.sombraPersonalizada,
    this.width = 350,
    this.height = 50,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.15),
            offset: Offset(0, 6),
            blurRadius: 8,
            spreadRadius: -4,
          ),
        ],
        borderRadius: BorderRadius.circular(25),
      ),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
            if (states.contains(WidgetState.pressed)) {
              return const Color.fromRGBO(33, 78, 62, 1.0);
            }
            return backgroundColor;
          }),
          foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
            if (states.contains(WidgetState.pressed)) {
              return Colors.white;
            }
            return textColor;
          }),
          elevation: WidgetStateProperty.all(elevation),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
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
