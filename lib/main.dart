import 'package:flutter/material.dart';
import 'package:syndra_app/login/login_screen.dart';
import 'package:syndra_app/splash/splash_screen.dart';
import 'package:syndra_app/intros/intro1.dart';
import 'package:syndra_app/intros/intro2.dart';
import 'package:syndra_app/intros/intro3.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginScreen(),

      routes: {
        '/intro1': (context) => const Intro1(),
        '/intro2': (context) => const Intro2(),
        '/intro3': (context) => const Intro3(),
      },
    );
  }
}
