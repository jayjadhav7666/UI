import 'package:flutter/material.dart';
import 'primo_web/primo_web_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Primo Web',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.light, fontFamily: 'Montserrat'),
      home: const PrimoWebScreen(),
    );
  }
}
