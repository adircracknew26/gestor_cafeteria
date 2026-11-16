// IA: Pruebas unitarias para validar el comportamiento del RepositorioFalso (fallo en la 1a llamada y éxito en la 2a).
import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_cafeteria/data/repositorio_falso.dart';

void main() {
  group('RepositorioFalso', () {
    late RepositorioFalso repositorio;

    setUp(() {
      repositorio = RepositorioFalso();
    });

    test('la primera llamada arroja una excepción para probar error y reintento', () async {
      expect(repositorio.llamadas, 0);
      expect(() => repositorio.obtener(), throwsA(isA<Exception>()));
    });

    test('la segunda llamada devuelve al menos 5 productos de ejemplo con éxito', () async {
      // 1ra llamada falla
      try {
        await repositorio.obtener();
      } catch (_) {}

      // 2da llamada tiene éxito
      final productos = await repositorio.obtener();
      expect(repositorio.llamadas, 2);
      expect(productos.length, greaterThanOrEqualTo(5));
      expect(productos.first.nombre, 'Café Americano');
    });
  });
}
