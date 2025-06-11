import 'package:flutter/material.dart';
import 'package:syndra_app/texto/tipoletra.dart';
import 'package:syndra_app/botones_base/boton_elevado.dart';
import 'package:url_launcher/url_launcher.dart';

class DonationsScreen extends StatefulWidget {
  const DonationsScreen({super.key});

  @override
  State<DonationsScreen> createState() => _DonationsScreenState();
}

class _DonationsScreenState extends State<DonationsScreen> {
  final TextEditingController _amountController = TextEditingController();
  double _selectedAmount = 0.0;

  final Color _donationButtonBg = const Color.fromRGBO(163, 217, 207, 1.0);
  final Color _donationButtonText = const Color.fromRGBO(33, 78, 62, 1.0);

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _processDonation() async {
    final monto = _selectedAmount > 0
        ? _selectedAmount.toInt()
        : (double.tryParse(_amountController.text) ?? 0).toInt();
    if (monto <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecciona o ingresa un monto válido antes de donar.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    // Cambia el número por el de tu cuenta Daviplata
    final phone = '3001234567';
    final url = Uri.parse('daviplata://sendmoney?phone=$phone&amount=$monto');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      // Si no funciona el deep link, abre la web de Daviplata
      final webUrl = Uri.parse(
        'https://www.daviplata.com/wps/portal/daviplata/web/personas/recargar-daviplata',
      );
      if (await canLaunchUrl(webUrl)) {
        await launchUrl(webUrl, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se pudo abrir Daviplata ni su web.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _openNequi() async {
    final monto = _selectedAmount > 0
        ? _selectedAmount.toInt()
        : (double.tryParse(_amountController.text) ?? 0).toInt();
    if (monto <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecciona o ingresa un monto válido antes de donar.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    final url = Uri.parse('nequi://send-money?phone=3001234567&amount=$monto');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No se pudo abrir Nequi.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Donaciones', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromRGBO(33, 78, 62, 1.0),
        iconTheme: const IconThemeData(color: Colors.white),
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
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              'Tu apoyo es fundamental para seguir ofreciendo herramientas y recursos a quienes lo necesitan.',
              style: menuSectionTitleStyle.copyWith(fontSize: 17),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
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
                color: Color.fromRGBO(33, 78, 62, 1.0),
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                hintText: 'Ej: 7500.00',
                hintStyle: TextStyle(
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
                fillColor: Colors.white.withOpacity(0.9),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 15.0,
                  horizontal: 20.0,
                ),
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  setState(() {
                    _selectedAmount = 0.0;
                  });
                }
              },
            ),
            const SizedBox(height: 30),
            BotonElevado(
              label: 'Daviplata',
              onPressed: _processDonation,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              width: 250,
              height: 55,
            ),
            const SizedBox(height: 20),
            BotonElevado(
              label: 'Nequi',
              onPressed: _openNequi,
              backgroundColor: Colors.purple,
              textColor: Colors.white,
              width: 250,
              height: 55,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDonationAmountButton(String label, double amount) {
    bool isSelected = _selectedAmount == amount;
    return BotonElevado(
      label: label,
      backgroundColor: isSelected ? _donationButtonText : _donationButtonBg,
      textColor: isSelected ? Colors.white : _donationButtonText,
      width: 200,
      height: 50,
      onPressed: () {
        setState(() {
          _selectedAmount = amount;
          _amountController.clear();
        });
      },
    );
  }
}
