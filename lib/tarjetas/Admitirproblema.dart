// ignore: duplicate_ignore
// ignore: file_names

// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:syndra_app/botones_base/boton_elevado.dart'; // Para tu BotonElevado
import 'package:syndra_app/texto/tipoletra.dart'; // Para tus estilos de texto

class AdmitirProblemaScreen extends StatefulWidget {
  // Callback para notificar que la pantalla se ha completado y el botón debe cambiar
  final VoidCallback onProblemAdmitted;

  const AdmitirProblemaScreen({super.key, required this.onProblemAdmitted});

  @override
  State<AdmitirProblemaScreen> createState() => _AdmitirProblemaScreenState();
}

class _AdmitirProblemaScreenState extends State<AdmitirProblemaScreen> {
  late YoutubePlayerController _controller;
  bool _isPlayerReady = false;
  bool _showContinueButton =
      false; // Controla la visibilidad del botón "Continuar"

  // ID del video de YouTube que quieres mostrar
  // Puedes cambiar este ID por cualquier video de YouTube
  // Por ejemplo, para un video de youtube.com/watch?v=dQw4w9WgXcQ, el ID es dQw4w9WgXcQ
  final String _videoId =
      'L9BDFFi36J4'; // <--- ¡CAMBIA ESTO POR EL ID REAL DE TU VIDEO!

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: _videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true, // Reproducir automáticamente
        mute: false,
        disableDragSeek:
            true, // No permitir arrastrar para buscar (para que vean el video completo)
        loop: false,
        forceHD: false,
        enableCaption: false,
      ),
    )..addListener(
      listener,
    ); // Añade un listener para monitorear el estado del video
  }

  void listener() {
    if (_isPlayerReady &&
        mounted &&
        _controller.value.playerState == PlayerState.ended) {
      // Si el video ha terminado, mostramos el botón de continuar
      setState(() {
        _showContinueButton = true;
      });
    }
    // Puedes añadir más lógica aquí si quieres mostrar el botón después de un tiempo específico
    // Por ejemplo:
    // if (_isPlayerReady && mounted && _controller.value.position.inSeconds >= 60 && !_showContinueButton) {
    //   setState(() {
    //     _showContinueButton = true;
    //   });
    //   print('Video lleva 1 minuto. Botón de continuar visible.');
    // }
  }

  @override
  void deactivate() {
    // Pausa el video cuando el widget no está visible
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Admitir un Problema',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromRGBO(
          33,
          78,
          62,
          1.0,
        ), // Tu color oscuro de AppBar
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: SingleChildScrollView(
        child: Container(
          color: Color.fromRGBO(163, 217, 207, 1.0),
          child: Column(
            // Fondo blanco para el cuerpo
            children: [
              YoutubePlayer(
                controller: _controller,
                showVideoProgressIndicator: true,
                progressIndicatorColor: Colors.blueAccent,
                onReady: () {
                  _isPlayerReady = true;
                },
                onEnded: (data) {
                  // Ya lo manejamos en el listener, pero puedes duplicar lógica aquí si es necesario
                  setState(() {
                    _showContinueButton = true;
                  });
                },
              ),

              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text(
                      '¡Bienvenido a este viaje de auto-descubrimiento!',
                      style: counterTitleStyle.copyWith(
                        fontSize: 22,
                        color: const Color.fromRGBO(33, 78, 62, 1.0),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 15),

                    Text(
                      'Este video es el primer paso para reconocer y admitir aquello que te está desafiando. Tómate el tiempo para reflexionar sobre su mensaje.',
                      style: menuSectionTitleStyle.copyWith(fontSize: 17),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),

                    // Botón "Continuar" que aparece después de ver el video
                    if (_showContinueButton) // Condición para mostrar el botón
                      BotonElevado(
                        label: 'Continuar en este viaje',
                        onPressed: () {
                          widget
                              .onProblemAdmitted(); // Llama al callback para notificar al Home
                          Navigator.pop(context); // Regresa al menú principal
                        },
                        backgroundColor: const Color.fromRGBO(
                          33,
                          78,
                          62,
                          1.0,
                        ), // Color principal
                        textColor: Colors.white,
                        width: 280,
                        height: 55,
                      )
                    else
                      // Mensaje o indicador de espera si el botón aún no debe aparecer
                      Column(
                        children: [
                          const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color.fromRGBO(120, 190, 180, 1.0),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'El botón aparecerá al terminar el video...',
                            style: menuSectionTitleStyle.copyWith(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
