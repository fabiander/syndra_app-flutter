// lib/contadores/counters_carousel.dart
import 'package:flutter/material.dart';
import 'package:syndra_app/contadores/tiempo.dart';
import 'package:syndra_app/texto/tipoletra.dart';
import 'package:syndra_app/colores_espacios/tonoscolores.dart'; // Asegúrate de que esta importación sea correcta para ColoresApp

class CountersCarousel extends StatefulWidget {
  const CountersCarousel({super.key});

  @override
  State<CountersCarousel> createState() => _CountersCarouselState();
}

class _CountersCarouselState extends State<CountersCarousel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final DateTime _abstinenceStartDate = DateTime.now().subtract(
    const Duration(days: 1, hours: 8, minutes: 30, seconds: 15),
  );

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page?.round() ?? 0;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromRGBO(163, 217, 207, 1.0),
        borderRadius: BorderRadius.circular(0),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              children: [
                _TimeCountersScreen(startDate: _abstinenceStartDate),
                // --- PÁGINA 2: IMAGEN LOCAL CON CONTENEDOR RECTANGULAR Y TRANSPARENTE ---
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Tu Guía en el Camino',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          color: ColoresApp.iconColor,
                        ),
                      ),
                      const SizedBox(height: 20),

                      Container(
                        width: 190,
                        height: 190,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              // ignore: deprecated_member_use
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                          image: const DecorationImage(
                            image: AssetImage('assets/images/logro.jpg'),
                            fit: BoxFit.contain,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Mi Primer Paso',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          color: ColoresApp.iconColor,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Siempre a tu lado en la recuperación.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                       const SizedBox(height: 5)
                    ],
                  ),
                ),
                // --- PÁGINA 3: POEMA DE METAS ---
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'El eco de tus metas',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            color: ColoresApp.iconColor,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'En cada paso, una nueva luz,\n'
                          'tu meta brilla, fuerte y veraz.\n'
                          'Hoy siembras lo que mañana darás,\n'
                          'libre y en paz, tu alma al fin fluye.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            color: ColoresApp.iconColor,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  height: 8.0,
                  width: _currentPage == index ? 24.0 : 8.0,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? const Color(0xFF6B45A8)
                        // ignore: deprecated_member_use
                        : Colors.grey.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

// Clase _TimeCountersScreen
class _TimeCountersScreen extends StatefulWidget {
  final DateTime startDate;

  const _TimeCountersScreen({required this.startDate});

  @override
  State<_TimeCountersScreen> createState() => _TimeCountersScreenState();
}

class _TimeCountersScreenState extends State<_TimeCountersScreen> {
  late TimeCounter _timeCounter;

  @override
  void initState() {
    super.initState();
    _timeCounter = TimeCounter(startDate: widget.startDate);
  }

  @override
  void dispose() {
    _timeCounter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Duration>(
      valueListenable: _timeCounter.elapsedTimeNotifier,
      builder: (context, elapsedTime, child) {
        final totalDays = _timeCounter.days;
        final remainingHours = _timeCounter.hours;
        final remainingMinutes = _timeCounter.minutes;
        final remainingSeconds = _timeCounter.seconds;

        return Center(
          // <--- ENVOLVEMOS TODA LA PÁGINA EN CENTER PARA CENTRADO TOTAL
          child: Padding(
            // Mantener el padding general
            padding: const EdgeInsets.only(top: 20.0, bottom: 35.0, right: 35.0, left: 35.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment
                  .center, // <--- CENTRA VERTICALMENTE LOS ELEMENTOS
              crossAxisAlignment: CrossAxisAlignment
                  .stretch, // <--- Hace que los hijos se estiren horizontalmente (para las filas de contador)
              children: [
                Text(
                  'He estado libre durante',
                  style: counterTitleStyle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),

                if (totalDays > 0)
                  _buildCounterRow(
                    label: '$totalDays ${totalDays == 1 ? 'día' : 'días'}',
                    value: _timeCounter.getProgressBarValue('dias'),
                    totalValue: totalDays, // Pasamos el valor numérico
                    barColor: Colors.pinkAccent,
                  ),
                if (totalDays == 0 || remainingHours > 0)
                  Padding(
                    padding: EdgeInsets.only(top: totalDays > 0 ? 15.0 : 0.0),
                    child: _buildCounterRow(
                      label:
                          '$remainingHours ${remainingHours == 1 ? 'hora' : 'horas'}',
                      value: _timeCounter.getProgressBarValue('horas'),
                      totalValue: remainingHours, // Pasamos el valor numérico
                      barColor: Colors.purpleAccent,
                    ),
                  ),
                if ((totalDays == 0 && remainingHours == 0) ||
                    remainingMinutes > 0)
                  Padding(
                    padding: EdgeInsets.only(
                      top: (totalDays > 0 || remainingHours > 0) ? 15.0 : 0.0,
                    ),
                    child: _buildCounterRow(
                      label:
                          '$remainingMinutes ${remainingMinutes == 1 ? 'minuto' : 'minutos'}',
                      value: _timeCounter.getProgressBarValue('minutos'),
                      totalValue: remainingMinutes, // Pasamos el valor numérico
                      barColor: Colors.amber,
                    ),
                  ),
                if ((totalDays == 0 &&
                        remainingHours == 0 &&
                        remainingMinutes == 0) ||
                    remainingSeconds > 0)
                  Padding(
                    padding: EdgeInsets.only(
                      top:
                          (totalDays > 0 ||
                              remainingHours > 0 ||
                              remainingMinutes > 0)
                          ? 15.0
                          : 0.0,
                    ),
                    child: _buildCounterRow(
                      label:
                          '$remainingSeconds ${remainingSeconds == 1 ? 'segundo' : 'segundos'}',
                      value: _timeCounter.getProgressBarValue('segundos'),
                      totalValue: remainingSeconds, // Pasamos el valor numérico
                      barColor: Colors.cyanAccent,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCounterRow({
    required String label,
    required double value,
    required Color barColor,
    required int totalValue, // Nuevo parámetro para el número total
  }) {
    // Definimos la altura deseada de la barra
    const double barHeight = 25.0; // <--- BARRA MÁS GRUESA

    return Row(
      children: [
        // La palabra (días, horas, etc.) al lado izquierdo
        Expanded(
          flex: 4, // Ajustamos la flex para dar más espacio a la etiqueta
          child: Text(
            // Extraemos solo la parte de texto de la etiqueta (ej. "día" de "1 día")
            label
                .split(' ')
                .sublist(1)
                .join(' '), // <--- EXTRAE SOLO LA PALABRA
            style: counterLabelStyle.copyWith(color: ColoresApp.iconColor),
            textAlign: TextAlign.left,
          ),
        ),
        const SizedBox(
          width: 10,
        ), // Pequeño espacio entre la palabra y la barra
        // La barra de progreso y el número total
        Expanded(
          flex: 9, // Ajustamos la flex para la barra y el número
          child: Row(
            // Usamos Row para alinear la barra y el número lado a lado
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Container(
                      height: barHeight, // Usamos la altura definida
                      decoration: BoxDecoration(
                        // ignore: deprecated_member_use
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(
                          barHeight / 2,
                        ), // Bordes redondeados según la nueva altura
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: value.clamp(0.0, 1.0),
                      child: Container(
                        height: barHeight, // Usamos la altura definida
                        decoration: BoxDecoration(
                          color: barColor,
                          borderRadius: BorderRadius.circular(
                            barHeight / 2,
                          ), // Bordes redondeados
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10), // Espacio entre la barra y el número
              // El número total al lado derecho
              Text(
                totalValue.toString(), // Muestra el valor numérico
                style: counterLabelStyle.copyWith(
                  color: ColoresApp.iconColor,
                ),
                textAlign: TextAlign.right,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
