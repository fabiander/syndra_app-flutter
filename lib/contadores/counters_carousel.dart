// lib/contadores/counters_carousel.dart
import 'package:flutter/material.dart';
import 'package:syndra_app/contadores/tiempo.dart';
import 'package:syndra_app/texto/tipoletra.dart'; // <--- IMPORTAMOS LOS ESTILOS

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
      height: MediaQuery.of(context).size.height * 0.55,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(163, 217, 207, 1.0),
        borderRadius: BorderRadius.circular(0),
        boxShadow: [
          BoxShadow(
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
                const Center(
                  child: Text(
                    'Aquí irá más información o contadores (Página 2)',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.black54),
                  ),
                ),
                const Center(
                  child: Text(
                    'Aquí irá más información o contadores (Página 3)',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.black54),
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
                    color:
                        _currentPage == index
                            ? const Color(0xFF6B45A8)
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

        return Padding(
          padding: const EdgeInsets.all(45.0),
          
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
        
          children: [
            Text(
              'He estado libre durante',
              style: counterTitleStyle,
              textAlign: TextAlign.center,
            ),
        
        
            const SizedBox(height: 20),
        
            if (totalDays > 0)
              _buildCounterRow(
                label: '$totalDays ${totalDays == 1 ? 'día' : 'días'}',
                value: _timeCounter.getProgressBarValue('dias'),
                barColor: Colors.pinkAccent,
              ),
        
            if (totalDays == 0 || remainingHours > 0)
              Padding(
                padding: EdgeInsets.only(top: totalDays > 0 ? 15.0 : 0.0),
                child: _buildCounterRow(
                  label:
                      '$remainingHours ${remainingHours == 1 ? 'hora' : 'horas'}',
                  value: _timeCounter.getProgressBarValue('horas'),
                  barColor: Colors.purpleAccent,
                ),
              ),
        
        
            if (totalDays == 0 && remainingHours == 0 || remainingMinutes > 0)
              Padding(
                padding: EdgeInsets.only(
                  top: (totalDays > 0 || remainingHours > 0) ? 15.0 : 0.0,
                ),
                child: _buildCounterRow(
                  label:
                      '$remainingMinutes ${remainingMinutes == 1 ? 'minuto' : 'minutos'}',
                  value: _timeCounter.getProgressBarValue('minutos'),
                  barColor: Colors.amber,
                ),
              ),
        
        
            if (totalDays == 0 && remainingHours == 0 && remainingMinutes == 0 || remainingSeconds > 0)
              Padding(
                padding: EdgeInsets.only(
                  top: (totalDays > 0 || remainingHours > 0 || remainingMinutes > 0) ? 15.0 : 0.0,
                ),
        
        
                child: _buildCounterRow(
                  label:
                      '$remainingSeconds ${remainingSeconds == 1 ? 'segundo' : 'segundos'}',
                  value: _timeCounter.getProgressBarValue('segundos'),
                  barColor: Colors.cyanAccent,
                ),
        
        
              ),
          ],
        ),
                ); 
      },
    );
  }

  Widget _buildCounterRow({
    required String label,
    required double value,
    required Color barColor,
  }) {
    return Row(
      children: [
        Expanded(flex: 3,
          child: Text(
            label,
            style: menuSectionTitleStyle, // <--- APLICAMOS counterLabelStyle AQUÍ
          ),
        ),


        Expanded(
          flex: 7,
          child: Stack(
            children: [
              Container(
                height: 25,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              FractionallySizedBox(
                widthFactor: value.clamp(0.0, 1.0),
                child: Container(
                  height: 25,
                  decoration: BoxDecoration(
                    color: barColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
