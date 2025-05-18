// botones_base/boton_con_icono.dart
import 'package:flutter/material.dart';

class BotonConIcono extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final Color iconColor;
  final double elevation;
  final VoidCallback onPressed;

  const BotonConIcono({
    super.key,
    required this.icon,
    required this.label,
    this.backgroundColor = Colors.blue,
    this.borderColor = Colors.transparent,
    this.textColor = Colors.white,
    this.iconColor = Colors.white,
    this.elevation = 4.0,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        elevation: elevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: BorderSide(color: borderColor, width: 1.5),
        ),
        minimumSize: Size(300, 50),
      ),
      icon: Icon(icon, color: iconColor),
      label: Text(label, style: TextStyle(color: textColor)),
      onPressed: onPressed,
    );
  }
}
