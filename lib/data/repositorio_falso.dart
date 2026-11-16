// IA: Repositorio falso para simular la obtención de productos con latencia y fallo en el primer intento.
import '../domain/producto.dart';

class RepositorioFalso {
  int _llamadas = 0;

  /// Retorna el número de llamadas realizadas (útil para pruebas y depuración).
  int get llamadas => _llamadas;

  /// Simula una petición de red con retraso de 2 segundos.
  /// Falla la primera vez para permitir probar el estado de error y reintento.
  /// A partir de la segunda llamada, devuelve al menos 5 productos de ejemplo.
  Future<List<Producto>> obtener() async {
    await Future.delayed(const Duration(seconds: 2));
    _llamadas++;

    if (_llamadas == 1) {
      throw Exception('Sin conexión'); // Falla deliberadamente en la 1a llamada
    }

    return const [
      Producto(
        id: '1',
        nombre: 'Café Americano',
        descripcion: 'Café de grano de Morelos (vaso de 500 ml)',
        precio: 25.00,
        categoria: 'Bebidas calientes',
        disponible: true,
      ),
      Producto(
        id: '2',
        nombre: 'Capuchino Vainilla',
        descripcion: 'Café espresso con leche espumada y toque de vainilla',
        precio: 38.00,
        categoria: 'Bebidas calientes',
        disponible: true,
      ),
      Producto(
        id: '3',
        nombre: 'Torta de Jamón con Queso',
        descripcion: 'Telera tradicional con aguacate, jitomate y queso panela',
        precio: 45.00,
        categoria: 'Alimentos',
        disponible: true,
      ),
      Producto(
        id: '4',
        nombre: 'Chilaquiles Verdes con Pollo',
        descripcion: 'Totopos con salsa verde de la casa, crema, queso y pollo',
        precio: 55.00,
        categoria: 'Alimentos',
        disponible: true,
      ),
      Producto(
        id: '5',
        nombre: 'Agua de Jamaica',
        descripcion: 'Infusión natural de flor de jamaica (vaso de 500 ml)',
        precio: 18.00,
        categoria: 'Bebidas frías',
        disponible: true,
      ),
    ];
  }
}
