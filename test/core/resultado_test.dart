// IA: Pruebas unitarias para validar la clase sellada Resultado y la entidad Producto.
import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_cafeteria/core/resultado.dart';
import 'package:gestor_cafeteria/domain/producto.dart';

void main() {
  group('Resultado<T>', () {
    test('Cargando se instancia y compara correctamente', () {
      const estado1 = Cargando<List<Producto>>();
      const estado2 = Cargando<List<Producto>>();
      expect(estado1, equals(estado2));
    });

    test('Exito almacena datos y evalúa igualdad', () {
      const producto = Producto(
        id: '1',
        nombre: 'Café Americano',
        descripcion: 'Café de grano',
        precio: 25.0,
        categoria: 'Bebidas calientes',
      );
      const exito1 = Exito([producto]);
      const exito2 = Exito([producto]);
      expect(exito1, equals(exito2));
      expect(exito1.datos.length, 1);
    });

    test('Error almacena mensaje legible', () {
      const error1 = Error<List<Producto>>('Sin conexión al servidor');
      const error2 = Error<List<Producto>>('Sin conexión al servidor');
      expect(error1, equals(error2));
      expect(error1.mensaje, 'Sin conexión al servidor');
    });

    test('switch sobre Resultado es exhaustivo sin necesidad de default', () {
      const Resultado<int> res = Exito(42);
      final descripcion = switch (res) {
        Cargando() => 'en_espera',
        Exito(datos: final d) => 'valor_$d',
        Error(mensaje: final m) => 'fallo_$m',
      };
      expect(descripcion, 'valor_42');
    });
  });
}
