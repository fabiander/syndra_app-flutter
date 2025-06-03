// lib/encuesta/inicio.dart

class Question {
  final String text;
  final List<String> options;
  final bool isNumericFrequency; // ¡Esta línea es la clave!

  Question({
    required this.text,
    required this.options,
    this.isNumericFrequency = false, // Y esta línea con el valor por defecto
  });
}
