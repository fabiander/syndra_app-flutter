
// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:syndra_app/botones_base/boton_elevado.dart';
import 'package:syndra_app/texto/tipoletra.dart';

class AdmitirProblemaScreen extends StatefulWidget {
  final VoidCallback onProblemAdmitted;

  const AdmitirProblemaScreen({super.key, required this.onProblemAdmitted});

  @override
  State<AdmitirProblemaScreen> createState() => _AdmitirProblemaScreenState();
}

class _AdmitirProblemaScreenState extends State<AdmitirProblemaScreen> {
  late YoutubePlayerController _controller;
  bool _isPlayerReady = false;
  bool _showContinueButton = false;

  final String _videoId = 'oWlhMekUZRs';

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: _videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        disableDragSeek: true,
        loop: false,
        forceHD: false,
        enableCaption: false,
      ),
    )..addListener(listener);
  }

  void listener() {
    if (_isPlayerReady &&
        mounted &&
        _controller.value.playerState == PlayerState.ended) {
      setState(() {
        _showContinueButton = true;
      });
    }
  }

  @override
  void deactivate() {
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
        backgroundColor: const Color.fromRGBO(33, 78, 62, 1.0),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            color: const Color.fromRGBO(163, 217, 207, 1.0),
            child: Column(
              children: [


                SizedBox(
                   height: constraints.maxHeight * 0.45, // Usa 0.38, 0.4, 0.5 según lo que prefieras
                  width: double.infinity,
                  child: YoutubePlayer(
                    controller: _controller,
                    showVideoProgressIndicator: true,
                    progressIndicatorColor: Colors.blueAccent,
                    onReady: () {
                      _isPlayerReady = true;
                    },
                    onEnded: (data) {
                      setState(() {
                        _showContinueButton = true;
                      });
                    },
                  ),
                ),




                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                          'Este video es el primer paso para reconocer y admitir aquello que te está desafiando. Tómate el tiempo para reflexionar sobre su mensaje',
                          style: menuSectionTitleStyle.copyWith(fontSize: 17),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 30),
                        if (_showContinueButton)
                          BotonElevado(
                            label: 'Continuar',
                            onPressed: () {
                              widget.onProblemAdmitted();
                              Navigator.pop(context);
                            },
                            backgroundColor: const Color.fromRGBO(
                              33,
                              78,
                              62,
                              1.0,
                            ),
                            textColor: Colors.white,
                            width: 280,
                            height: 55,
                          )
                        else
                          Text(
                            'El botón aparecerá al terminar el video...',
                            style: menuSectionTitleStyle.copyWith(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
