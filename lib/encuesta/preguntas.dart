import 'package:flutter/material.dart';
import 'package:syndra_app/encuesta/inicio.dart'; // Asegúrate de que esta ruta sea correcta para tu modelo Question

class SurveyOverlay extends StatefulWidget {
  final VoidCallback
  onSurveyCompleted; // Callback para cuando la encuesta termine
  final VoidCallback
  onExitSurvey; // Callback para cuando el usuario sale de la encuesta

  const SurveyOverlay({
    super.key,
    required this.onSurveyCompleted,
    required this.onExitSurvey,
  });

  @override
  State<SurveyOverlay> createState() => _SurveyOverlayState();
}

class _SurveyOverlayState extends State<SurveyOverlay> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  // Aquí guardaremos las respuestas del usuario (clave: índice de pregunta, valor: respuesta String)
  final Map<int, String> _userAnswers = {};

  // Controlador para el TextField de texto libre
  final TextEditingController _freeTextController = TextEditingController();

  // Define tus 5 preguntas aquí
  final List<Question> _questions = [
    // Primera Pregunta: Frecuencia con opciones numéricas en cuadros
    Question(
      text: '¿Cuantas veces al dia consumes marihuana? ',
      options: ['1', '2', '3', '4', '5', '6'],
      isNumericFrequency: true,
      isFreeText: false,
    ),
    // Segunda Pregunta: Botones de lista vertical (estilo original)
    Question(
      text: '¿Alguna vez has intentado dejar tu consumo?',
      options: ['Sí', 'No', 'No se'],
      isNumericFrequency: false,
      isFreeText: false,
    ),
    // Tercera Pregunta: Botones de lista vertical (estilo original)
    Question(
      text: '¿El consumo afecta tus compromisos (trabajo, estudios, hogar)?',
      options: ['Si', 'No', 'no se'],
      isNumericFrequency: false,
      isFreeText: false,
    ),
    // Cuarta Pregunta: Botones de lista vertical (estilo original)
    Question(
      text: '¿Hubo una experiencia o momento en tu vida que inicio tu consumo?',
      options: ['Si', 'No', 'No se'],
      isNumericFrequency: false,
      isFreeText: false,
    ),
    // Quinta Pregunta: Texto libre con caja de texto pequeña (maxLines: 1)
    Question(
      text: '¿Tu proposito o persona por quien quieres dejarla?',
      options: null, // Pasa null para una pregunta de texto libre
      isFreeText: true, // ¡Marca esta pregunta como de texto libre!
      isNumericFrequency: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      if (_pageController.page?.round() != _currentPage) {
        setState(() {
          // Guarda el texto de la página anterior antes de cambiar
          if (_questions[_currentPage].isFreeText == true) {
            _userAnswers[_currentPage] = _freeTextController.text.trim();
          }
          _currentPage = _pageController.page!.round();
          _updateFreeTextController(); // Actualiza el controlador de texto al cambiar a la nueva página
        });
      }
    });
    _updateFreeTextController(); // Configura el controlador inicial al cargar el widget
  }

  // Método para actualizar el TextField con la respuesta guardada
  void _updateFreeTextController() {
    if (_questions[_currentPage].isFreeText == true) {
      _freeTextController.text = _userAnswers[_currentPage] ?? '';
    }
  }

  void _nextPage() {
    final currentQuestion = _questions[_currentPage];

    // Lógica de validación para preguntas de texto libre
    if (currentQuestion.isFreeText == true) {
      final text = _freeTextController.text.trim();
      if (text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor, escribe tu respuesta para continuar.'),
          ),
        );
        return;
      }
      _userAnswers[_currentPage] = text; // Guarda el texto libre
    }
    // Para preguntas de opciones, la validación y avance se hacen en _onOptionSelected.
    // Aquí solo se ejecuta si estamos en la última pregunta de texto libre O si se llama
    // _nextPage directamente sin una opción seleccionada (que no debería ocurrir si la opción es automática).

    if (_currentPage < _questions.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeIn,
      );
    } else {
      // Última pregunta, la encuesta ha terminado
      print(
        'Encuesta completada. Respuestas: $_userAnswers',
      ); // Para depuración
      widget
          .onSurveyCompleted(); // Llama al callback para cerrar el overlay o navegar
    }
  }

  // Método para volver a la página anterior
  void _previousPage() {
    // Si la pregunta actual es de texto libre, guarda el texto antes de retroceder
    if (_questions[_currentPage].isFreeText == true) {
      _userAnswers[_currentPage] = _freeTextController.text.trim();
    }

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
    // Solo avanzamos automáticamente si NO es la última pregunta o si no es de texto libre
    if (_currentPage < _questions.length - 1 &&
        _questions[_currentPage].isFreeText != true) {
      _nextPage();
    }
    // Si es la última pregunta y de texto libre, el avance lo gestiona el botón "Finalizar"
  }

  // Llama a este método cuando el usuario decida salir al menú
  void _exitSurvey() {
    widget.onExitSurvey();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Dialog(
      backgroundColor:
          Colors.transparent, // ✨ FONDODEL DIÁLOGO COMPLETAMENTE TRANSPARENTE ✨
      clipBehavior: Clip.antiAlias,
      child: Center(
        child: Container(
          height: screenHeight * 0.8,
          width: screenWidth * 0.9,
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
              // ENCABEZADO CON BOTÓN "VOLVER" Y NÚMERO DE PREGUNTA
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
                          size: 28,
                        ),
                        onPressed: _previousPage,
                        tooltip: 'Volver a la pregunta anterior',
                        // splashRadius: 24, // Eliminado por compatibilidad con Material 3
                      )
                    else
                      const SizedBox(
                        width: 48,
                      ), // Espacio para alinear el título
                    // Texto de la pregunta X de Y
                    Expanded(
                      child: Text(
                        'Pregunta ${_currentPage + 1} de ${_questions.length}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6B45A8),
                        ),
                      ),
                    ),
                    // Botón "Salir al Menú" en la esquina superior derecha
                    IconButton(
                      icon: const Icon(
                        Icons.close, // Un ícono de "X" o cerrar
                        color: Colors.grey,
                        size: 28,
                      ),
                      onPressed: _exitSurvey,
                      tooltip: 'Salir de la encuesta',
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, thickness: 1, color: Colors.grey),

              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  physics:
                      const NeverScrollableScrollPhysics(), // Deshabilita el deslizamiento manual
                  itemCount: _questions.length,
                  onPageChanged: (index) {
                    setState(() {
                      // Guarda el texto libre si se sale de la página actual
                      if (_questions[_currentPage].isFreeText == true) {
                        _userAnswers[_currentPage] = _freeTextController.text
                            .trim();
                      }
                      _currentPage = index;
                      _updateFreeTextController(); // Actualiza el controlador para la nueva página
                    });
                  },
                  itemBuilder: (context, index) {
                    final question = _questions[index];
                    return SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 20.0,
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

                          // LÓGICA CONDICIONAL PARA MOSTRAR TEXTFIELD O LAS OPCIONES
                          if (question.isFreeText == true)
                            Column(
                              // Usamos Column para el TextField y el botón Finalizar
                              children: [
                                TextField(
                                  controller: _freeTextController,
                                  maxLines:
                                      1, // Esto hace la caja pequeña para 1 o 2 palabras
                                  decoration: InputDecoration(
                                    hintText: 'Escribe tu propósito aquí...',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        color: Color(0xFF6B45A8),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        color: Color(0xFF6B45A8),
                                        width: 2,
                                      ),
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey[100],
                                  ),
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.done,
                                ),
                                const SizedBox(
                                  height: 30,
                                ), // Espacio entre el TextField y el botón
                                // Botón "Finalizar" solo para la última pregunta de texto libre
                                ElevatedButton(
                                  onPressed:
                                      _nextPage, // _nextPage manejará la finalización
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF6B45A8),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 15,
                                    ),
                                  ),
                                  child: const Text(
                                    'Finalizar',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              ],
                            )
                          else if (question.isNumericFrequency == true)
                            Wrap(
                              alignment: WrapAlignment.center,
                              spacing: 15.0,
                              runSpacing: 15.0,
                              children: question.options!.map((option) {
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
                          else // Preguntas con opciones de botón normales
                            ...question.options!.map((option) {
                              final isSelected =
                                  _userAnswers[_currentPage] == option;
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8.0,
                                ),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: isSelected
                                        ? const Color(0xFF6B45A8)
                                        : Colors.grey[200],
                                    foregroundColor: isSelected
                                        ? Colors.white
                                        : Colors.black87,
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
              // BARRA DE PROGRESO DE LADO A LADO EN LA PARTE INFERIOR
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
    _freeTextController.dispose();
    super.dispose();
  }
}
