// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:syndra_app/colores_espacios/tonoscolores.dart';
// ignore: unused_import
import 'package:syndra_app/mainmenu/menu.dart';
import 'package:syndra_app/olvidopasword/ventanasdialog.dart';
import 'package:syndra_app/encuesta/inicio.dart'; // Asegúrate de que esta ruta sea correcta para tu modelo Question

class SurveyOverlay extends StatefulWidget {
  final String? initialFreeText;
  final int? initialPage;

  const SurveyOverlay({super.key, this.initialFreeText, this.initialPage, required Null Function() onExitSurvey, required Null Function(String freeText) onSurveyCompleted});

  @override
  State<SurveyOverlay> createState() => _SurveyOverlayState();
}

class _SurveyOverlayState extends State<SurveyOverlay> {
  late PageController _pageController = PageController();
  int _currentPage = 0;
  final Map<int, String> _userAnswers = {};
  late TextEditingController _freeTextController = TextEditingController();

  final List<Question> _questions = [
    Question(
      text: '¿Cuantas veces al dia consumes marihuana? ',
      options: ['1', '2', '3', '4', '5', '6'],
      isNumericFrequency: true,
      isFreeText: false,
    ),
    Question(
      text: '¿Alguna vez has intentado dejar tu consumo?',
      options: ['Sí', 'No', 'No se'],
      isNumericFrequency: false,
      isFreeText: false,
    ),
    Question(
      text: '¿El consumo afecta tus compromisos (trabajo, estudios, hogar)?',
      options: ['Si', 'No', 'no se'],
      isNumericFrequency: false,
      isFreeText: false,
    ),
    Question(
      text: '¿Hubo una experiencia o momento en tu vida que inicio tu consumo?',
      options: ['Si', 'No', 'No se'],
      isNumericFrequency: false,
      isFreeText: false,
    ),
    Question(
      text: '¿Tu proposito o persona por quien quieres dejarla?',
      options: null,
      isFreeText: true,
      isNumericFrequency: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _freeTextController = TextEditingController(
      text: widget.initialFreeText ?? '',
    );
    _currentPage = widget.initialPage ?? 0;
    _pageController = PageController(initialPage: _currentPage);
    _pageController.addListener(() {
      if (_pageController.page?.round() != _currentPage) {
        setState(() {
          if (_questions[_currentPage].isFreeText == true) {
            _userAnswers[_currentPage] = _freeTextController.text.trim();
          }
          _currentPage = _pageController.page!.round();
          _updateFreeTextController();
        });
      }
    });
    _updateFreeTextController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _currentPage = widget.initialPage ?? 0;
        _updateFreeTextController();
      });
    });
  }

  void _updateFreeTextController() {
    if (_questions[_currentPage].isFreeText == true) {
      _freeTextController.text = _userAnswers[_currentPage] ?? '';
    }
  }

  void _nextPage() {
    final currentQuestion = _questions[_currentPage];
    if (currentQuestion.isFreeText == true) {
      final text = _freeTextController.text.trim();
      if (text.isEmpty) {
        showCustomAlertDialog(
          context: context,
          icon: Icons.error,
          buttonText: 'Error',
          message: 'Escribe tu respuesta para continuar.',
          buttonColor: Colors.deepOrangeAccent,
          borderColor: Colors.deepOrangeAccent,
        );
        return;
      }
      _userAnswers[_currentPage] = text;
    }
    if (_currentPage < _questions.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeIn,
      );
    } else {
      // Última pregunta, retorna el texto al menú
      Navigator.of(context).pop(_freeTextController.text.trim());
    }
  }

  void _previousPage() {
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
      _userAnswers[_currentPage] = option;
    });
    if (_currentPage < _questions.length - 1 &&
        _questions[_currentPage].isFreeText != true) {
      _nextPage();
    }
  }

  void _exitSurvey() {
    Navigator.of(context).pop(_freeTextController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Dialog(
      backgroundColor: Colors.transparent,
      clipBehavior: Clip.antiAlias,
      child: Center(
        child: Container(
          height: screenHeight * 0.8,
          width: screenWidth * 0.9,
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(255),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: ColoresApp.backgroundColor,
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (_currentPage > 0)
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: ColoresApp.iconColor,
                          size: 28,
                        ),
                        onPressed: _previousPage,
                        tooltip: 'Volver a la pregunta anterior',
                      )
                    else
                      const SizedBox(width: 48),
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
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: ColoresApp.iconColor,
                        size: 28,
                      ),
                      onPressed: _exitSurvey,
                      tooltip: 'Salir de la encuesta',
                    ),
                  ],
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _questions.length,
                  onPageChanged: (index) {
                    setState(() {
                      if (_questions[_currentPage].isFreeText == true) {
                        _userAnswers[_currentPage] = _freeTextController.text
                            .trim();
                      }
                      _currentPage = index;
                      _updateFreeTextController();
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
                          if (question.isFreeText == true)
                            Column(
                              children: [
                                TextField(
                                  controller: _freeTextController,
                                  maxLines: 1,
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
                                const SizedBox(height: 30),
                                SizedBox(
                                  width: 220,
                                  child: ElevatedButton(
                                    onPressed: _nextPage,
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
                          else
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
                            }),
                        ],
                      ),
                    );
                  },
                ),
              ),
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
