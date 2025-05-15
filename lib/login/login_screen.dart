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

            Align(                           //   alinacion sube  
              alignment: Alignment.topCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: Colors.green, width: 2),
                    ),

                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [

                        Container(
                          margin: EdgeInsets.only(top: 20),
                          padding: EdgeInsets.all(36),
                          child: Image.asset(
                            'assets/images/login_logo.png',
                            fit: BoxFit.cover,
                          ),
                        ),

                        Container(
                          margin: EdgeInsets.only(top: 20),
                          padding: EdgeInsets.all(36),

                          
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center, 
                            children: [
                              Container(
                                child:_buildInputField(
                                  Icons.email,
                                  'Correo electrónico',
                                ), 
                              ),

                              Container(
                                child: _buildInputField(
                                  Icons.lock,
                                  'Contraseña',
                                )
                              )

                            ],
                          


                          ),
                          
                        ),
                        // Aquí puedes agregar más containers o widgets
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(IconData icon, String hint) {
    return TextField(
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        hintText: hint,
        border: OutlineInputBorder(),
      ),
    );
  }
}





Containe(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person, size: 50, color: Colors.teal),
                      ),
              
                      
                      const SizedBox(height: 30),
                      _buildInputField(Icons.email, 'Correo electrónico'),
                      const SizedBox(height: 15),
                      _buildInputField(Icons.lock, 'Contraseña', obscureText: true),
                      const SizedBox(height: 30),
                      _buildButton('Ingreso', () {
                        // Acción de login
                      }),
                      const SizedBox(height: 15),
                      _buildButton('Registro', () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegistroScreen(),
                          ),
                        );
                      }),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: () {
                          // Recuperar contraseña
                        },
                        child: const Text('¿Olvidó su contraseña?'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],





          Widget _buildInputField(
    IconData icon,
    String hint, {
    bool obscureText = false,
  }) {
    return TextField(
      obscureText: obscureText,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        hintText: hint,
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
        border: const OutlineInputBorder(borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(vertical: 15),
      ),
    );
  }

  Widget _buildButton(String label, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 45,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.teal,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        onPressed: onPressed,
        child: Text(label, style: const TextStyle(fontSize: 16)),
      ),
    );
  }