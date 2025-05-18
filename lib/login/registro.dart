import 'package:flutter/material.dart';
import 'package:syndra_app/botones_base/boton_elevado.dart';
import 'package:syndra_app/login/cajas.dart';

class RegistroScreen extends StatelessWidget {
  const RegistroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(color: Color.fromRGBO(163, 217, 207, 1.0)),



        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/img_media.png',
              fit: BoxFit.cover,
              ),
              ),
          


            Align(
              alignment: Alignment.topCenter,

              child: Column(
                
                children: [
                  Container(
                    width: 340,
                    height: 700,
                    margin: const EdgeInsets.only(top: 95),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(
                        color: const Color.fromRGBO(63, 140, 112, 1.0),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),

                    child: Column( 
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                     
                      children: [

                        Container(
                          width: 300,
                          margin: const EdgeInsets.only(top: 20),
                          padding: const EdgeInsets.all(10),

                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [

                              SizedBox(
                                width: 400,
                                child: cajastexto('Nombre', icon: Icons.person),
                                
                              ),

                              const SizedBox(height: 35),
                              
                              SizedBox(
                                width: 400,
                                child: cajastexto('Edad', icon: Icons.calendar_today),
                              ),

                              const SizedBox(height: 35),

                              SizedBox(
                                width: 400,
                                child: cajastexto('Email', icon: Icons.email),
                              ),

                              const SizedBox(height: 35),

                              SizedBox(
                                width: 400,
                                child: cajastexto('Usuario', icon: Icons.person),
                              ),

                              const SizedBox(height: 35),

                              SizedBox(
                                width: 400,
                                child: cajastexto('Contraseña', icon: Icons.lock),
                              ),

                              const SizedBox(height: 35),

                          
                              
                        Container(
                          padding: const EdgeInsets.only(top: 20),
                          margin: const EdgeInsets.only(top: 25),
                          child: BotonElevado(label: 'Guardar', onPressed: () {}
                                ),
                        ),
                            ],
                          ), 
                        ),
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
}
