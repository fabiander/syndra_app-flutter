// lib/utils/tiempo.dart
import 'dart:async';
import 'package:flutter/foundation.dart'; // Para ValueNotifier

class TimeCounter {
  final DateTime startDate;
  late Timer _timer;
  final ValueNotifier<Duration> elapsedTimeNotifier; // Para notificar cambios

  TimeCounter({required this.startDate})
      : elapsedTimeNotifier = ValueNotifier<Duration>(Duration.zero) {
    _startTimer();
  }

  void _startTimer() {
    // Calcular la duración inicial
    _updateElapsedTime();

    // Iniciar un timer que se ejecuta cada segundo
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateElapsedTime();
    });
  }

  void _updateElapsedTime() {
    final now = DateTime.now();
    final newElapsedTime = now.difference(startDate);
    // Solo actualiza si el tiempo ha cambiado, para evitar reconstrucciones innecesarias
    if (newElapsedTime != elapsedTimeNotifier.value) {
      elapsedTimeNotifier.value = newElapsedTime;
    }
  }

  // Método para detener el contador cuando ya no se necesite
  void stop() {
    _timer.cancel();
  }

  // Para liberar los recursos del ValueNotifier
  void dispose() {
    _timer.cancel();
    elapsedTimeNotifier.dispose();
  }

  // Métodos para obtener los componentes de la duración (útiles para la UI)
  int get days => elapsedTimeNotifier.value.inDays;
  int get hours => elapsedTimeNotifier.value.inHours.remainder(24);
  int get minutes => elapsedTimeNotifier.value.inMinutes.remainder(60);
  int get seconds => elapsedTimeNotifier.value.inSeconds.remainder(60);

  // Helper para calcular el valor de la barra de progreso
  // La lógica de la barra de progreso aquí debe ser revisada y ajustada según tus metas.
  // Por ahora, es un ejemplo que muestra el porcentaje de la unidad actual.
  double getProgressBarValue(String unit) {
    switch (unit) {
      case 'dias':
        // Ejemplo: progreso dentro de un periodo de 30 días
        return (elapsedTimeNotifier.value.inDays % 30) / 30.0;
      case 'horas':
        // Progreso dentro de las 24 horas
        return (elapsedTimeNotifier.value.inHours % 24) / 24.0;
      case 'minutos':
        // Progreso dentro de los 60 minutos
        return (elapsedTimeNotifier.value.inMinutes % 60) / 60.0;
      case 'segundos':
        // Progreso dentro de los 60 segundos
        return (elapsedTimeNotifier.value.inSeconds % 60) / 60.0;
      default:
        return 0.0;
    }
  }
}