// lib/olvidopasword/custom_alert_dialog.dart (o lib/widgets/custom_alert_dialog.dart)

import 'package:flutter/material.dart';

// Puedes definir tus colores aquí o importarlos desde tu archivo tonoscolores.dart
// Si tienes una paleta centralizada, ¡es lo ideal!
// import 'package:syndra_app/colores/tonoscolores.dart'; // Si lo necesitas

/// Función para mostrar una alerta personalizada con un ícono, mensaje y botón centrado.
///
/// [context]: El BuildContext desde donde se muestra el diálogo.
/// [icon]: El icono a mostrar (ej. Icons.error, Icons.check_circle).
/// [message]: El mensaje principal del diálogo.
/// [buttonText]: Texto del botón de acción (por defecto 'Aceptar').
/// [buttonColor]: Color de fondo del botón. Define el acento del diálogo (éxito/error).
/// [dialogBackgroundColor]: Color de fondo del cuerpo del diálogo.
/// [borderColor]: Color del borde del diálogo (por defecto el mismo que buttonColor).
/// [messageTextColor]: Color del texto del mensaje.
/// [buttonTextColor]: Color del texto del botón.

Future<void> showCustomAlertDialog({
  required BuildContext context,
  required IconData icon,
  required String message,
  String buttonText = 'Aceptar',
  // --- Colores principales para el diálogo ---
  Color buttonColor = const Color.fromRGBO(
    255,
    99,
    71,
    1.0,
  ), // Rojo tomate fuerte para errores
  // >>> ¡¡¡CORRECCIÓN AQUÍ: FONDO DEL DIÁLOGO CLARO!!! <<<
  Color dialogBackgroundColor = const Color.fromRGBO(
    245,
    245,
    245,
    0.8,
  ), // Un gris muy, muy claro (casi blanco)

  // O si prefieres blanco puro, usa: Color dialogBackgroundColor = Colors.white;
  Color borderColor = const Color.fromRGBO(
    255,
    99,
    71,
    1.0,
  ), // Por defecto el mismo color que buttonColor
  // >>> ¡¡¡CORRECCIÓN AQUÍ: TEXTO DEL MENSAJE OSCURO PARA CONTRASTE!!! <<<
  Color messageTextColor =
      Colors.black87, // Un negro suave para el texto en fondo claro

  // O si prefieres un gris más definido: Color messageTextColor = Colors.grey[800]!;
  Color buttonTextColor = Colors
      .white, // Texto del botón blanco (contrasta con el color del botón fuerte)
}) async {
  print(
    'DEBUG: ¡Mostrando el CustomAlertDialog con la paleta CLARA definitiva!',
  ); // Un print para confirmar

  return showDialog<void>(
    context: context,
    barrierDismissible:
        false, // El usuario debe tocar el botón para cerrar el diálogo
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        // --- COLORES MEJORADOS ---
        backgroundColor:
            dialogBackgroundColor, // Fondo del diálogo: ¡AHORA SÍ CLARO!
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(
            color: borderColor, // Borde con el color de acento
            width: 2,
          ),
        ),
        content: Column(
          mainAxisSize:
              MainAxisSize.min, // Ajusta el tamaño de la columna al contenido
          children: <Widget>[
            Icon(
              icon,
              color: buttonColor, // El icono toma el color del botón (acento)
              size: 60.0, // Tamaño grande para el icono
            ),
            const SizedBox(height: 15), // Espacio entre el icono y el texto
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: messageTextColor,
                fontSize: 18,
              ), // Texto: ¡AHORA SÍ OSCURO!
            ),
            const SizedBox(height: 25), // Espacio entre el texto y el botón
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
                child: Text(
                  buttonText,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
