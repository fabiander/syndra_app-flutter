// lib/contadores/counters_carousel.dart
import 'package:flutter/material.dart';

class CountersCarousel extends StatefulWidget {
  const CountersCarousel({Key? key}) : super(key: key);

  @override
  State<CountersCarousel> createState() => _CountersCarouselState();
}

class _CountersCarouselState extends State<CountersCarousel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

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
      height:
          MediaQuery.of(context).size.height *
          0.55, // Ajusta la altura del carrusel según la imagen
      decoration: BoxDecoration(
        color: const Color(
          0xFFC8E6C9,
        ), // Color de fondo verde muy claro similar a la imagen
        borderRadius: BorderRadius.circular(25),
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
              children: const [
                // Pantalla 1: Contadores de tiempo
                _TimeCountersScreen(),
                // Pantalla 2: Puedes añadir otro tipo de contador o información
                Center(
                  child: Text(
                    'Aquí irá más información o contadores (Página 2)',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.black54),
                  ),
                ),
                // Pantalla 3: Otra pantalla de contadores o gráficos
                Center(
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
                // 3 puntos para 3 páginas
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

class _TimeCountersScreen extends StatelessWidget {
  const _TimeCountersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'He estado libre durante',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white, // Texto blanco como en la imagen
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          _buildCounterRow(
            label: '1 día',
            value: 1.0,
            barColor: Colors.pinkAccent,
          ), //
          const SizedBox(height: 15),
          _buildCounterRow(
            label: '8 horas',
            value: 0.8,
            barColor: Colors.purpleAccent,
          ), //
          const SizedBox(height: 15),
          _buildCounterRow(
            label: '2 minutos',
            value: 0.2,
            barColor: Colors.amber,
          ), //
          const SizedBox(height: 15),
          _buildCounterRow(
            label: '23 segundos',
            value: 0.5,
            barColor: Colors.cyanAccent,
          ), //
        ],
      ),
    );
  }

  Widget _buildCounterRow({
    required String label,
    required double value, // Valor de 0.0 a 1.0 para la barra de progreso
    required Color barColor,
  }) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
            ), // Texto blanco
          ),
        ),
        Expanded(
          flex: 7,
          child: Stack(
            children: [
              Container(
                height: 25,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(
                    0.3,
                  ), // Fondo de la barra claro
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              FractionallySizedBox(
                widthFactor: value, // Ancho de la barra de progreso
                child: Container(
                  height: 25,
                  decoration: BoxDecoration(
                    color: barColor, // Color de la barra de progreso
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
