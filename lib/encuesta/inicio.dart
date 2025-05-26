// lib/models/question.dart
class Question {
  final String text;
  final List<String> options; // Opciones de respuesta
  // Puedes añadir más propiedades si necesitas:
  // final int correctAnswerIndex; // Si hay respuestas correctas
  // final QuestionType type; // Ej: multiple_choice, text_input

  Question({required this.text, required this.options});
}

// Puedes añadir una enumeración para el tipo de pregunta si las preguntas varían
// enum QuestionType { multipleChoice, singleChoice, textInput }
