import 'package:flutter/material.dart';
import 'package:syndra_app/texto/tipoletra.dart'; // Para tus estilos de texto
import 'package:url_launcher/url_launcher.dart';
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

  void _callPadrino() async {
    const phoneNumber =
        '+573001234567'; // Cambia por el número real de tu padrino
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);

    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo iniciar la llamada.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _sendMessage() async {
    String message = _messageController.text.trim();
    if (message.isEmpty) {
      message =
          'Necesito hablar contigo.'; // Mensaje predeterminado si el campo está vacío
    }

    // Ejemplo de envío por SMS (puedes cambiar el número)
    final Uri smsUri = Uri(
      scheme: 'sms',
      path: '+573153309870', // Cambia por el número real de tu padrino
      queryParameters: <String, String>{'body': message},
    );

    if (await canLaunchUrl(smsUri)) {
      await launchUrl(smsUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se pudo enviar el mensaje.'),
          backgroundColor: Colors.red,
        ),
      );
    }
    _messageController.clear(); // Limpiar el campo después de "enviar"
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Padrino', style: TextStyle(color: Colors.white)),
        backgroundColor: _primaryButtonBg,
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
              width: 280,
              height: 60,
              elevation: 8.0,
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
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Ej: "Necesito un momento, ¿puedes hablar?"',
                hintStyle: TextStyle(
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
              backgroundColor: _secondaryButtonBg,
              textColor: _secondaryButtonText,
              width: 280,
              height: 55,
            ),
          ],
        ),
      ),
    );
  }
}
