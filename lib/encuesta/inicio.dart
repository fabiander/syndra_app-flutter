// lib/encuesta/inicio.dart

class Question {
  final String text;
  final List<String>? options;
  final bool? isFreeText;
  final bool? isNumericFrequency;

  Question({
    required this.text,
    this.options,
    this.isFreeText,
    this.isNumericFrequency,
  });
}
