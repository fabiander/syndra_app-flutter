// lib/bararriba/arriba.dart

import 'package:flutter/material.dart';
import 'package:syndra_app/colores_espacios/tonoscolores.dart';

class MyAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBarWidget({
    super.key,
    required this.userName,
    required this.surveyDataText,
    this.onLogoutPressed,
  });

  final String userName;
  final String surveyDataText;
  final VoidCallback? onLogoutPressed;

  // Definimos los colores aquí, de forma independiente.
  static const Color appBarBackgroundColor = ColoresApp.barColor; // Color de fondo de la AppBar
  static const Color appBarIconAndTextColor = ColoresApp.iconColor; // Color verde oscuro para iconos y texto

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: appBarBackgroundColor,
      elevation: 0,
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: Icon(Icons.menu, color: appBarIconAndTextColor),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        },
      ),
      title: Row(
        // El título sigue siendo un Row
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween, // Distribuye los elementos
        children: [
          Text(
            'Hola $userName', // Saludo al usuario
            style: TextStyle(
              color: appBarIconAndTextColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          


             //<--- CAMBIO AQUÍ: Luego el texto del problema/encuesta (irá a la derecha)
          Text(
            surveyDataText, // Dato de la encuesta
            style: TextStyle(
              color: appBarIconAndTextColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),


      
      centerTitle:
          false, // Importante para que mainAxisAlignment.spaceBetween funcione
      actions: [
        IconButton(
          icon: Icon(
            Icons.exit_to_app_sharp,
            color: appBarIconAndTextColor,
          ), // Icono de salir
          onPressed: onLogoutPressed, // Llama al callback cuando se presiona
        ),
      ],
    );
  }

  @override
  Size get preferredSize => AppBar().preferredSize;
}
