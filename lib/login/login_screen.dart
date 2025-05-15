import 'package:flutter/material.dart';
import 'registro.dart'; // Para navegar desde el botón

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Color.fromRGBO(163, 217, 207, 1.0)),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/img_media.png',
                fit: BoxFit.cover,
              ),
            ),

            Align(
              //   alinacion sube
              alignment: Alignment.topCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  Container(
                    width: 340,
                    height: 700,
                    margin: EdgeInsets.only(top: 95),
                    //padding: EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(
                        color: Color.fromRGBO(63, 140, 112, 1.0),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),

                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          //  ESTE ES EL LOGO
                          margin: EdgeInsets.only(top: 20),
                          padding: EdgeInsets.all(16),
                          child: Image.asset(
                            'assets/images/login_logo.png',
                            fit: BoxFit.cover,
                          ),
                        ),

                        Container(
                          width: 300,
                          // caja de email y contraseña
                          margin: EdgeInsets.only(top: 20),
                          padding: EdgeInsets.all(10),

                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 400,
                                child: _buildInputField(
                                  Icons.email,
                                  'Correo electrónico',
                                ),
                              ),

                              SizedBox(height: 10),
                              Container(
                                child: _buildInputField(
                                  Icons.lock,
                                  'Contraseña',
                                ),
                              ),
                            ],
                          ),
                        ),

                        Container(
                          width: 300,
                          margin: EdgeInsets.only(top: 20),
                          padding: EdgeInsets.all(26),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                child: _buildButton('Ingreso', () {
                                  // Acción de login
                                }),
                              ),

                              SizedBox(height: 20),

                              Container(
                                child: _buildSpecialButton('Registro', () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => const RegistroScreen(),
                                    ),
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),
                        // Aquí puedes agregar más containers o widgets
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(IconData icon, String hint) {
    return TextField(
      style: TextStyle(
        fontFamily: 'Raleway',
        fontWeight: FontWeight.w500, // Medium
        fontSize: 18,
        color: Color.fromRGBO(33, 78, 62, 1.0), // Color del texto ingresado
      ),

      decoration: InputDecoration(
        prefixIcon: Icon(
          icon,
          color: Color.fromRGBO(33, 78, 62, 1.0),
        ), // Icono verde
        hintText: hint,
        hintStyle: TextStyle(
          color: Color.fromRGBO(33, 78, 62, 1.0), // Color del hint (verde)
          fontFamily: 'Raleway',
          fontWeight: FontWeight.w500,
          fontSize: 18,
        ),
        border: UnderlineInputBorder(),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.teal), // Color de la línea
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.teal, width: 2),
        ),
      ),
    );
  }
}

Widget _buildButton(String label, VoidCallback onPressed) {
  return SizedBox(
    width: 300,
    height: 45,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.teal,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      ),
      onPressed: onPressed,
      child: Text(label, style: const TextStyle(fontSize: 18)),
    ),
  );
}

// Nuevo widget para un botón con decoración diferente
Widget _buildSpecialButton(String label, VoidCallback onPressed) {
  return SizedBox(
    width: 300,
    height: 45,
    child: Stack(
      children: [
        // Sombra debajo
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.3),
                  offset: Offset(0, 6), // Solo abajo
                  blurRadius: 4,
                  spreadRadius: 0,
                ),
              ],
            ),
          ),
        ),
        // Botón encima
        Positioned.fill(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  Colors
                      .white, // Fondo sólido para que no se vea la sombra dentro
              foregroundColor: Colors.teal,
              elevation: 0, // Sin sombra interna
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                  color: Color.fromRGBO(242, 242, 242, 1.0),
                  width: 2,
                ),
              ),
            ),
            onPressed: onPressed,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Raleway',
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
