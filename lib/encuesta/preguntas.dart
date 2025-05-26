// lib/survey/survey_overlay.dart
import 'package:flutter/material.dart';
import 'package:syndra_app/encuesta/inicio.dart'; // Importa tu modelo de pregunta

class SurveyOverlay extends StatefulWidget {
  final VoidCallback
  onSurveyCompleted; // Callback para cuando la encuesta termine

  const SurveyOverlay({super.key, required this.onSurveyCompleted});

  @override
  State<SurveyOverlay> createState() => _SurveyOverlayState();
}

class _SurveyOverlayState extends State<SurveyOverlay> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  // Aquí guardaremos las respuestas del usuario
  final Map<int, String> _userAnswers = {};

  // Define tus 5 preguntas aquí
  final List<Question> _questions = [
    Question(
      text:
          '¿Con qué frecuencia sientes una fuerte necesidad de consumir marihuana?',
      options: [
        'Nunca',
        'Raramente',
        'A veces',
        'Frecuentemente',
        'Casi siempre',
      ],
    ),
    Question(
      text:
          '¿Alguna vez has intentado reducir o controlar tu consumo de marihuana y no has podido?',
      options: [
        'Sí, una vez',
        'Sí, varias veces',
        'No he intentado',
        'No, nunca he tenido necesidad',
      ],
    ),
    Question(
      text:
          '¿El consumo de marihuana interfiere significativamente con tus responsabilidades (trabajo, estudios, hogar)?',
      options: [
        'Nunca',
        'Raramente',
        'A veces',
        'Frecuentemente',
        'Sí, muy a menudo',
      ],
    ),
    Question(
      text:
          '¿Continúas consumiendo marihuana a pesar de saber que te está causando problemas físicos o psicológicos?',
      options: ['No', 'Raramente', 'A veces', 'Sí, a menudo'],
    ),
    Question(
      text:
          '¿Necesitas consumir mayores cantidades de marihuana para conseguir el efecto deseado, o el efecto de la misma cantidad ha disminuido significativamente?',
      options: ['No', 'Un poco', 'Sí, notablemente'],
    ),
  ];

  void _nextPage() {
    if (_currentPage < _questions.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      // Última pregunta, la encuesta ha terminado
      widget.onSurveyCompleted();
      // Opcional: Podrías enviar _userAnswers a un servicio o guardarlos aquí
      print('Encuesta completada. Respuestas: $_userAnswers');
    }
  }

  void _onOptionSelected(String option) {
    setState(() {
      _userAnswers[_currentPage] = option; // Guarda la respuesta
    });
    _nextPage(); // Pasa a la siguiente pregunta automáticamente al seleccionar una opción
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor:
          Colors
              .transparent, // Fondo transparente para que el desenfoque se vea
      // Este clipBehavior asegura que el contenido no se salga de los bordes redondeados del diálogo.
      clipBehavior: Clip.antiAlias,
      child: Center(
        child: Container(
          height:
              MediaQuery.of(context).size.height *
              0.7, // Ajusta la altura del diálogo
          width: MediaQuery.of(context).size.width * 0.85, // Ajusta el ancho
          decoration: BoxDecoration(
            color: Colors.white, // Fondo blanco para el contenido del diálogo
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Pregunta ${_currentPage + 1} de ${_questions.length}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6B45A8), // Color púrpura
                  ),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  physics:
                      const NeverScrollableScrollPhysics(), // Evita el deslizamiento manual
                  itemCount: _questions.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    final question = _questions[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 10.0,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            question.text,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 30),
                          ...question.options.map((option) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                              ),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      _userAnswers[_currentPage] == option
                                          ? Color(0xFF6B45A8)
                                          : Colors
                                              .grey[200], // Resalta la opción seleccionada
                                  foregroundColor:
                                      _userAnswers[_currentPage] == option
                                          ? Colors.white
                                          : Colors.black87,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 15,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: () => _onOptionSelected(option),
                                child: Text(
                                  option,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          }),
                          // Botón siguiente (opcional, si no quieres que elijas la opción para avanzar)
                          // if (_currentPage < _questions.length - 1)
                          //   const SizedBox(height: 20),
                          //   ElevatedButton(
                          //     onPressed: _nextPage,
                          //     child: const Text('Siguiente'),
                          //   ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              // Puedes añadir un indicador de progreso de la encuesta aquí
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: LinearProgressIndicator(
                  value: (_currentPage + 1) / _questions.length,
                  backgroundColor: Colors.grey[300],
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFF6B45A8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
