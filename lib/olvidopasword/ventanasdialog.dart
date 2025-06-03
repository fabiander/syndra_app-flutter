import 'package:flutter/material.dart';
import 'package:syndra_app/colores_espacios/espacios.dart';
import 'package:syndra_app/texto/tipoletra.dart';


Future<void> showCustomAlertDialog({
  required BuildContext context,
  required IconData icon,
  required String message,
  String buttonText = 'Aceptar',
 
  Color buttonColor = const Color.fromRGBO(255, 99, 71, 1.0,), // Rojo tomate fuerte para errores
  Color dialogBackgroundColor = const Color.fromRGBO(245, 245, 245, 0.8,), // Un gris muy, muy claro 
  Color borderColor = const Color.fromRGBO(255, 99, 71, 1.0,), 
  
  Color messageTextColor = Colors.black87, 
  Color buttonTextColor = Colors.white, 
}) async {
  
  return showDialog<void>(
    context: context,
    barrierDismissible: false,  // El usuario debe tocar el botón para cerrar el diálogo

    builder: (BuildContext dialogContext) {

      return AlertDialog(
        backgroundColor: dialogBackgroundColor, // Fondo del diálogo: ¡AHORA SÍ CLARO!
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(
            color: borderColor, // Borde con el color de acento
            width: 2,
          ),
        ),

        content: Column(
          mainAxisSize: MainAxisSize.min, // Ajusta el tamaño de la columna al contenido
          children: <Widget>[Icon(icon,
              color: buttonColor, // El icono toma el color del botón (acento)
              size: 70.0, // Tamaño grande para el icono
            ),

            Espacios.espacio15, // Espacio entre el icono y el texto

            Text(
              message,
              textAlign: TextAlign.center,
              style: menuSectionTitleStyle.copyWith(
                color: messageTextColor,
              )
            ),

            Espacios.espacio20,
             
            SizedBox(
              width: double.infinity, // El botón ocupa todo el ancho disponible
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop(); // Cierra el diálogo
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor, // Color de fondo del botón
                  foregroundColor: buttonTextColor, // Color del texto del botón
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(buttonText, 
                style: menuSectionTitleStyle.copyWith(
                  color: messageTextColor, // Color del texto del botón
                )),
              ),
            ),
          ],
        ),
      );
    },
  );
}
