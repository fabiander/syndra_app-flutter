import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFFA4D9CF),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
        

          children: [

            Image.asset(
              'assets/images/logo.png',
              width: 200,
              height: 200,
            ),

            SizedBox(height: 20),

            Text(
              'Syndra',
              style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold, color: const Color.fromRGBO(33, 78, 62, 1.0)),
            ), 
          ],
        ),
      ),

    ),
  );
 }
}