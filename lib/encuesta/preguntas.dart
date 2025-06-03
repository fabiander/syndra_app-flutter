import 'package:flutter/material.dart';
import 'package:syndra_app/encuesta/inicio.dart'; // Asegúrate de que esta ruta sea correcta para tu modelo Question

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
  // Aquí guardaremos las respuestas del usuario (clave: índice de pregunta, valor: respuesta String)
  final Map<int, String> _userAnswers = {};

  // Define tus 5 preguntas aquí
  final List<Question> _questions = [
    // ✨ PRIMERA PREGUNTA: Frecuencia con opciones numéricas en cuadros ✨
    Question(
      text: '¿Cuantas veces al dia consumes marihuana? ',
      options: ['1', '2', '3', '4', '5', '6'], // Opciones numéricas simples
      isNumericFrequency:
          true, // Propiedad para identificar este tipo de pregunta
    ),
    // Segunda Pregunta: Botones de lista vertical (estilo original)
    Question(
      text:
          '¿crees que tu consumo fue por alguna mala experiencia en tu vida ?',
      options: ['Sí', 'No', 'No se'],
    ),
    // Tercera Pregunta: Botones de lista vertical (estilo original)
    Question(
      text:
          '¿El consumo afecta tus responsabilidades (trabajo, estudios, hogar)?',
      options: ['Si', 'No', 'A veces', 'Nunca'],
    ),
    // Cuarta Pregunta: Botones de lista vertical (estilo original)
    Question(
      text: '¿haz intentado dejar la drogradicion, cuantas veces en este año?',
      options: ['No', 'Raramente', 'A veces', 'Sí, a menudo'],
    ),
    // Quinta Pregunta: Botones de lista vertical (estilo original)
    Question(
      text: '¿Cual es tu proposito o por quien quieres dejarla?',
      options: ['No', 'Un poco', 'Sí, notablemente'],
    ),
  ];

  void _nextPage() {
    // Validar que se haya seleccionado una opción para la pregunta actual antes de avanzar
    if (_userAnswers[_currentPage] == null ||
        _userAnswers[_currentPage]!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, selecciona una opción para continuar.'),
        ),
      );
      return; // No avanza si no hay respuesta
    }

    if (_currentPage < _questions.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeIn,
      );
    } else {
      // Última pregunta, la encuesta ha terminado
      // Aquí podrías procesar las respuestas en _userAnswers
      print(
        'Encuesta completada. Respuestas: $_userAnswers',
      ); // Para depuración
      widget
          .onSurveyCompleted(); // Llama al callback para cerrar el overlay o navegar
    }
  }

  // Método para volver a la página anterior
  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    }
  }

  void _onOptionSelected(String option) {
    setState(() {
      _userAnswers[_currentPage] = option; // Guarda la respuesta seleccionada
    });
    _nextPage(); // Pasa a la siguiente pregunta automáticamente al seleccionar una opción
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Dialog(
      backgroundColor: Colors.transparent, // Fondo transparente del diálogo
      clipBehavior: Clip
          .antiAlias, // Asegura que el contenido respete los bordes redondeados
      child: Center(
        child: Container(
          height: screenHeight * 0.8, // 80% de la altura de la pantalla
          width: screenWidth * 0.9, // 90% del ancho de la pantalla
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
              // ✨ NUEVO ENCABEZADO CON BOTÓN "VOLVER" Y NÚMERO DE PREGUNTA ✨
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Botón "Volver" (solo visible si no es la primera pregunta)
                    if (_currentPage > 0)
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Color(0xFF6B45A8),
                        ),
                        onPressed: _previousPage,
                        tooltip:
                            'Volver a la pregunta anterior', // Texto de ayuda
                      )
                    else
                      // Placeholder para mantener el espacio si no hay botón
                      const SizedBox(
                        width: 48,
                      ), // Ancho aproximado del IconButton
                    // Texto de la pregunta X de Y
                    Expanded(
                      child: Text(
                        'Pregunta ${_currentPage + 1} de ${_questions.length}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6B45A8), // Color púrpura
                        ),
                      ),
                    ),
                    // Placeholder para equilibrar el diseño si no hay botón en la izquierda
                    const SizedBox(
                      width: 48,
                    ), // Ancho aproximado del IconButton
                  ],
                ),
              ),
              const Divider(
                height: 1,
                thickness: 1,
                color: Colors.grey,
              ), // Separador visual

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
                    return SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 20.0, // Aumentado para mejor separación
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

                          // LÓGICA CONDICIONAL PARA MOSTRAR LAS OPCIONES
                          if (question.isNumericFrequency == true)
                            Wrap(
                              alignment: WrapAlignment.center,
                              spacing: 15.0,
                              runSpacing: 15.0,
                              children: question.options.map((option) {
                                final isSelected =
                                    _userAnswers[_currentPage] == option;
                                return GestureDetector(
                                  onTap: () => _onOptionSelected(option),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? Colors.blueAccent
                                          : Colors.grey[200],
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: isSelected
                                            ? Colors.blue
                                            : Colors.grey.shade400,
                                        width: 2,
                                      ),
                                      boxShadow: isSelected
                                          ? [
                                              BoxShadow(
                                                color: Colors.blue.withOpacity(
                                                  0.4,
                                                ),
                                                blurRadius: 8,
                                                offset: const Offset(0, 4),
                                              ),
                                            ]
                                          : [],
                                    ),
                                    child: Center(
                                      child: Text(
                                        option,
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: isSelected
                                              ? Colors.white
                                              : Colors.black87,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            )
                          else
                            ...question.options.map((option) {
                              final isSelected =
                                  _userAnswers[_currentPage] == option;
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8.0,
                                ),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: isSelected
                                        ? const Color(
                                            0xFF6B45A8,
                                          ) // Color púrpura si está seleccionada
                                        : Colors
                                              .grey[200], // Gris claro si no está seleccionada
                                    foregroundColor: isSelected
                                        ? Colors
                                              .white // Texto blanco si está seleccionada
                                        : Colors
                                              .black87, // Texto oscuro si no está seleccionada
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 15,
                                      horizontal: 10,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () => _onOptionSelected(option),
                                  child: Text(
                                    option,
                                    textAlign: TextAlign.center,
                                    softWrap: true,
                                    overflow: TextOverflow.visible,
                                  ),
                                ),
                              );
                            }).toList(),
                        ],
                      ),
                    );
                  },
                ),
              ),
              // ✨ BARRA DE PROGRESO DE LADO A LADO EN LA PARTE INFERIOR ✨
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: LinearProgressIndicator(
                  value: (_currentPage + 1) / _questions.length,
                  backgroundColor: Colors.grey[300],
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFF6B45A8), // Color púrpura
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
