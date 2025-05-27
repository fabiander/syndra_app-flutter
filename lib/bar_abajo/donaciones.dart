// lib/donaciones/donations_screen.dart
import 'package:flutter/material.dart';
import 'package:syndra_app/texto/tipoletra.dart'; // Para usar tus estilos de texto
import 'package:syndra_app/botones_base/boton_elevado.dart'; // Para usar tu BotonElevado

class DonationsScreen extends StatefulWidget {
  const DonationsScreen({super.key});

  @override
  State<DonationsScreen> createState() => _DonationsScreenState();
}

class _DonationsScreenState extends State<DonationsScreen> {
  final TextEditingController _amountController = TextEditingController();
  double _selectedAmount = 0.0; // Cantidad seleccionada o ingresada

  // Definimos los colores base para el botón de donación
  final Color _donationButtonBg = const Color.fromRGBO(
    163,
    217,
    207,
    1.0,
  ); // Tu color de fondo claro
  final Color _donationButtonText = const Color.fromRGBO(
    33,
    78,
    62,
    1.0,
  ); // Tu color de texto oscuro

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _processDonation() {
    // Aquí iría la lógica real para procesar la donación.
    // Por ahora, solo mostraremos un mensaje simulado.

    // Intentar parsear el texto del controlador si hay una cantidad personalizada
    if (_amountController.text.isNotEmpty) {
      final customAmount = double.tryParse(_amountController.text);
      if (customAmount != null && customAmount > 0) {
        _selectedAmount = customAmount;
      } else {
        // Si no se pudo parsear o es 0/negativo, y no hay cantidad predefinida seleccionada,
        // avisar al usuario.
        if (_selectedAmount == 0.0) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Por favor, ingresa una cantidad válida para donar.',
              ),
              backgroundColor: Colors.red,
            ),
          );
          return; // Salir de la función si no hay cantidad válida
        }
      }
    } else {
      // Si el campo está vacío, asegúrate de que se haya seleccionado una cantidad predefinida
      if (_selectedAmount == 0.0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Por favor, selecciona una cantidad o ingresa una personalizada.',
            ),
            backgroundColor: Colors.red,
          ),
        );
        return; // Salir de la función
      }
    }

    // Si llegamos aquí, tenemos una _selectedAmount válida
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '¡Gracias por tu donación de \$${_selectedAmount.toStringAsFixed(2)}! (Simulado)',
        ),
        backgroundColor: Colors.green,
      ),
    );

    // Opcional: Limpiar el campo y resetear la selección después de la "donación"
    _amountController.clear();
    setState(() {
      _selectedAmount = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Donaciones', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromRGBO(
          33,
          78,
          62,
          1.0,
        ), // Tu color oscuro de AppBar
        iconTheme: const IconThemeData(
          color: Colors.white,
        ), // Color de la flecha de retroceso
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Ayúdanos a mantener este proyecto funcionando',
              style: counterTitleStyle.copyWith(
                fontSize: 24,
                color: _donationButtonText,
              ), // Usando un estilo de texto existente
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            Text(
              'Tu apoyo es fundamental para seguir ofreciendo herramientas y recursos a quienes lo necesitan.',
              style: menuSectionTitleStyle.copyWith(
                fontSize: 17,
              ), // Usando un estilo de texto existente
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            // Opciones de donación predefinidas
            _buildDonationAmountButton('5.000 COP', 5000.0),
            const SizedBox(height: 15),
            _buildDonationAmountButton('10.000 COP', 10000.0),
            const SizedBox(height: 15),
            _buildDonationAmountButton('20.000 COP', 20000.0),
            const SizedBox(height: 15),
            _buildDonationAmountButton('50.000 COP', 50000.0),

            const SizedBox(height: 40),
            Text(
              'O ingresa otra cantidad:',
              style: menuSectionTitleStyle.copyWith(fontSize: 16),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                color: Color.fromRGBO(
                  33,
                  78,
                  62,
                  1.0,
                ), // Color del texto de entrada
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                hintText: 'Ej: 7500.00',
                hintStyle: TextStyle(
                  // ignore: deprecated_member_use
                  color: _donationButtonText.withOpacity(0.5),
                ),
                prefixText: '\$',
                suffixText: ' COP',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: _donationButtonBg),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: _donationButtonText, width: 2),
                ),
                filled: true,
                // ignore: deprecated_member_use
                fillColor: Colors.white.withOpacity(0.9),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 15.0,
                  horizontal: 20.0,
                ),
              ),
              onChanged: (value) {
                // Limpiar la selección de botones predefinidos si se escribe algo
                if (value.isNotEmpty) {
                  setState(() {
                    _selectedAmount = 0.0;
                  });
                }
              },
            ),
            const SizedBox(height: 30),
            BotonElevado(
              label: 'Donar ahora',
              onPressed: _processDonation,
              backgroundColor:
                  _donationButtonText, // Usar el color oscuro para el botón final
              textColor: Colors.white,
              width: 250, // Ajusta el ancho si es necesario
              height: 55, // Ajusta la altura si es necesario
            ),
          ],
        ),
      ),
    );
  }

  // Widget helper para los botones de cantidad predefinida
  Widget _buildDonationAmountButton(String label, double amount) {
    bool isSelected = _selectedAmount == amount;
    return BotonElevado(
      label: label,
      backgroundColor:
          isSelected
              ? _donationButtonText
              : _donationButtonBg, // Cambia de color si está seleccionado
      textColor: isSelected ? Colors.white : _donationButtonText,
      width: 200, // Ancho fijo para estos botones
      height: 50,
      onPressed: () {
        setState(() {
          _selectedAmount = amount;
          _amountController
              .clear(); // Limpiar el campo de texto si se selecciona un botón
        });
      },
    );
  }
}
