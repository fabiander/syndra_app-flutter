// lib/barfondo/llamado.dart
import 'package:flutter/material.dart';
import 'package:syndra_app/texto/tipoletra.dart'; // Para tus estilos de texto
import 'package:syndra_app/botones_base/boton_elevado.dart'; // Para tu BotonElevado

class LlamadoScreen extends StatefulWidget {
  const LlamadoScreen({super.key});

  @override
  State<LlamadoScreen> createState() => _LlamadoScreenState();
}

class _LlamadoScreenState extends State<LlamadoScreen> {
  final TextEditingController _messageController = TextEditingController();

  // Colores para los botones, manteniendo tu paleta
  final Color _primaryButtonBg = const Color.fromRGBO(
    33,
    78,
    62,
    1.0,
  ); // Verde oscuro
  final Color _primaryButtonText = Colors.white;
  final Color _secondaryButtonBg = const Color.fromRGBO(
    163,
    217,
    207,
    1.0,
  ); // Verde claro
  final Color _secondaryButtonText = const Color.fromRGBO(33, 78, 62, 1.0);

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _callPadrino() {
    // Lógica simulada de llamada
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Simulando llamada a tu Padrino...'),
        backgroundColor: Colors.blueAccent,
      ),
    );
    // Aquí iría la integración real con `url_launcher` para hacer una llamada
    // Ejemplo: launchUrl(Uri.parse('tel:+1234567890'));
  }

  void _sendMessage() {
    // Lógica simulada de envío de mensaje
    String message = _messageController.text.trim();
    if (message.isEmpty) {
      message =
          'Necesito hablar contigo.'; // Mensaje predeterminado si el campo está vacío
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Simulando envío de mensaje: "$message" a tu Padrino...'),
        backgroundColor: Colors.orange,
      ),
    );
    _messageController.clear(); // Limpiar el campo después de "enviar"

    // Aquí iría la integración real con `url_launcher` para enviar SMS/WhatsApp
    // Ejemplo SMS: launchUrl(Uri.parse('sms:+1234567890?body=$message'));
    // Ejemplo WhatsApp: launchUrl(Uri.parse('whatsapp://send?phone=+1234567890&text=$message'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Padrino', style: TextStyle(color: Colors.white)),
        backgroundColor:
            _primaryButtonBg, // Usando el color de AppBar consistente
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '¿Necesitas apoyo inmediato?',
              style: counterTitleStyle.copyWith(
                fontSize: 24,
                color: _primaryButtonBg,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            Text(
              'En momentos difíciles, tu padrino está aquí para escucharte y guiarte.',
              style: menuSectionTitleStyle.copyWith(fontSize: 17),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 50),

            BotonElevado(
              label: 'Llamar a mi Padrino',
              onPressed: _callPadrino,
              backgroundColor: _primaryButtonBg,
              textColor: _primaryButtonText,
              width: 280, // Ancho consistente para los botones principales
              height: 60,
              elevation: 8.0, // Un poco más de elevación para resaltar
            ),
            const SizedBox(height: 30),

            Text(
              'O envía un mensaje rápido:',
              style: menuSectionTitleStyle.copyWith(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),

            TextField(
              controller: _messageController,
              maxLines: 3, // Permite múltiples líneas para un mensaje
              decoration: InputDecoration(
                hintText: 'Ej: "Necesito un momento, ¿puedes hablar?"',
                hintStyle: TextStyle(
                  // ignore: deprecated_member_use
                  color: _secondaryButtonText.withOpacity(0.5),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: _secondaryButtonBg, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: _primaryButtonBg, width: 2),
                ),
                filled: true,
                // ignore: deprecated_member_use
                fillColor: Colors.white.withOpacity(0.9),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 15.0,
                  horizontal: 20.0,
                ),
              ),
              style: TextStyle(fontSize: 16, color: _secondaryButtonText),
            ),
            const SizedBox(height: 20),

            BotonElevado(
              label: 'Enviar Mensaje',
              onPressed: _sendMessage,
              backgroundColor:
                  _secondaryButtonBg, // Usando el color de fondo claro
              textColor:
                  _secondaryButtonText, // Usando el color de texto oscuro
              width: 280,
              height: 55,
            ),
          ],
        ),
      ),
    );
  }
}
