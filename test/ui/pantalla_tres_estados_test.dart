// IA: Pruebas de widgets para validar los tres estados (Cargando, Error con reintento, Exito).
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_cafeteria/data/repositorio_falso.dart';
import 'package:gestor_cafeteria/ui/pantalla_tres_estados.dart';

void main() {
  group('PantallaTresEstados Widget Tests', () {
    testWidgets('Muestra Cargando al iniciar, luego Error y al pulsar Reintentar muestra la lista',
        (tester) async {
      final repositorio = RepositorioFalso();

      await tester.pumpWidget(
        MaterialApp(
          home: PantallaTresEstados(repositorio: repositorio),
        ),
      );

      // 1. Estado inicial: Cargando
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Cargando productos...'), findsOneWidget);

      // Esperar que complete la 1a llamada (falla deliberadamente a los 2s)
      await tester.pump(const Duration(seconds: 2));
      await tester.pump();

      // 2. Estado de Error
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(
        find.text('No se pudo conectar con el servidor. Revisa tu conexión a internet.'),
        findsOneWidget,
      );
      expect(find.text('Reintentar'), findsOneWidget);

      // 3. Pulsar botón Reintentar
      await tester.tap(find.text('Reintentar'));
      await tester.pump(); // Inicia la recarga

      // Vuelve a estar en Cargando
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Esperar 2 segundos para que la 2da llamada tenga éxito
      await tester.pump(const Duration(seconds: 2));
      await tester.pump();

      // 4. Estado de Éxito: Lista de productos cargada
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('Café Americano'), findsOneWidget);
      expect(find.text('Capuchino Vainilla'), findsOneWidget);
      expect(find.text('Torta de Jamón con Queso'), findsOneWidget);
      expect(find.byType(Card), findsAtLeastNWidgets(5));
    });
  });
}
