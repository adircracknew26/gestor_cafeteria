// IA: Punto de entrada de la aplicación configurado con Material 3 y la pantalla de tres estados.
import 'package:flutter/material.dart';
import 'ui/pantalla_tres_estados.dart';

void main() {
  runApp(const CafeteriaApp());
}

class CafeteriaApp extends StatelessWidget {
  const CafeteriaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestor Cafetería',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6750A4)),
        useMaterial3: true,
      ),
      home: const PantallaTresEstados(),
    );
  }
}
