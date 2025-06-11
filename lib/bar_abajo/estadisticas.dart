// lib/barfondo/estadisticas.dart

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // Importa la librería de gráficos

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  // --- Datos de ejemplo para el progreso diario ---
  final List<double> dailyCommitment = [
    3.0, // Día 1
    4.0, // Día 2
    3.5, // Día 3
    5.0, // Día 4
    2.0, // Día 5
    4.5, // Día 6
    4.0, // Día 7 (Hoy)
  ];

  // Colores personalizados para cada barra del gráfico
  final List<Color> barColors = [
    Colors.blueAccent,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.redAccent,
    Colors.teal,
    Colors.amber,
  ];

  // Datos para los contadores principales
  int daysSober = 120; // Días sin consumir
  double moneySaved = 350.75; // Dinero ahorrado
  int cigarettesNotSmoked = 2400; // Cigarros no fumados

  @override
  Widget build(BuildContext context) {
    final Color appBarColor = const Color.fromRGBO(163, 217, 207, 1.0);
    final Color iconTextColor = const Color.fromRGBO(33, 78, 62, 1.0);
    final Color appBackgroundColor = const Color.fromRGBO(163, 217, 207, 1.0);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Estadísticas de Recuperación',
          style: TextStyle(color: iconTextColor),
        ),
        backgroundColor: appBarColor,
        iconTheme: IconThemeData(color: iconTextColor),
      ),
      body: Stack(
        children: [
          Positioned.fill(child: Container(color: appBackgroundColor)),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Sección de Contadores Principales
                _buildStatCard(
                  context,
                  title: 'Días Limpio',
                  value: '$daysSober',
                  unit: 'días',
                  icon: Icons.calendar_today,
                  color: Colors.white,
                  textColor: iconTextColor,
                ),
                const SizedBox(height: 16),
                _buildStatCard(
                  context,
                  title: 'Dinero Ahorrado',
                  value: '\$${moneySaved.toStringAsFixed(2)}',
                  unit: 'USD',
                  icon: Icons.savings,
                  color: Colors.white,
                  textColor: iconTextColor,
                ),
                const SizedBox(height: 16),
                _buildStatCard(
                  context,
                  title: 'Cigarros No Fumados',
                  value: '$cigarettesNotSmoked',
                  unit: 'cigarrillos',
                  icon: Icons.smoking_rooms,
                  color: Colors.white,
                  textColor: iconTextColor,
                ),
                const SizedBox(height: 24),

                // --- Gráfico de Progreso Diario ---
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 5,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Progreso de Compromiso Diario',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: iconTextColor,
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 250,
                          child: BarChart(
                            BarChartData(
                              alignment: BarChartAlignment.spaceAround,
                              maxY: 5,
                              barTouchData: BarTouchData(enabled: false),
                              titlesData: FlTitlesData(
                                show: true,
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: getBottomTitles,
                                    reservedSize: 30,
                                  ),
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: getLeftTitles,
                                    reservedSize: 40,
                                  ),
                                ),
                                topTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                rightTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                              ),
                              gridData: const FlGridData(show: false),
                              borderData: FlBorderData(
                                show: true,
                                border: Border.all(
                                  color: Colors.grey.shade300,
                                  width: 1,
                                ),
                              ),
                              barGroups: dailyCommitment.asMap().entries.map((
                                entry,
                              ) {
                                int index = entry.key;
                                double value = entry.value;
                                return BarChartGroupData(
                                  x: index,
                                  barRods: [
                                    BarChartRodData(
                                      toY: value,
                                      color:
                                          barColors[index % barColors.length],
                                      width: 16,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Sección de Historia de Mi Recuperación
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 5,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Historia de Mi Recuperación',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: iconTextColor,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          '10/05/2024: Comencé mi recuperación.',
                          style: TextStyle(color: Colors.grey),
                        ),
                        const Text(
                          '15/05/2024: Primer hito: 5 días sin consumir.',
                          style: TextStyle(color: Colors.grey),
                        ),
                        const Text(
                          '20/05/2024: Recaída leve. Me levanté y seguí.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget auxiliar para construir las tarjetas de estadísticas
  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required String unit,
    required IconData icon,
    required Color color,
    required Color textColor,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      elevation: 5,
      color: color,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 25.0),
        child: Column(
          children: [
            Icon(icon, size: 40, color: textColor),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),
            Text(unit, style: TextStyle(fontSize: 18, color: textColor)),
          ],
        ),
      ),
    );
  }

  // Función para las etiquetas del eje X (inferior) del gráfico
  Widget getBottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.grey,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('Día 1', style: style);
        break;
      case 1:
        text = const Text('Día 2', style: style);
        break;
      case 2:
        text = const Text('Día 3', style: style);
        break;
      case 3:
        text = const Text('Día 4', style: style);
        break;
      case 4:
        text = const Text('Día 5', style: style);
        break;
      case 5:
        text = const Text('Día 6', style: style);
        break;
      case 6:
        text = const Text('Hoy', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }
    return SideTitleWidget(axisSide: meta.axisSide, child: text);
  }

  // Función para las etiquetas del eje Y (izquierdo) del gráfico
  Widget getLeftTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.grey,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    if (value == 0) {
      text = '0';
    } else if (value == 1) {
      text = '1';
    } else if (value == 2) {
      text = '2';
    } else if (value == 3) {
      text = '3';
    } else if (value == 4) {
      text = '4';
    } else if (value == 5) {
      text = '5';
    } else {
      return Container();
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(text, style: style),
    );
  }
}
