// IA: Entidad del dominio de la Cafetería que representa un producto del menú.
class Producto {
  const Producto({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.categoria,
    this.disponible = true,
  });

  final String id;
  final String nombre;
  final String descripcion;
  final double precio;
  final String categoria;
  final bool disponible;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Producto &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          nombre == other.nombre &&
          descripcion == other.descripcion &&
          precio == other.precio &&
          categoria == other.categoria &&
          disponible == other.disponible;

  @override
  int get hashCode =>
      id.hashCode ^
      nombre.hashCode ^
      descripcion.hashCode ^
      precio.hashCode ^
      categoria.hashCode ^
      disponible.hashCode;
}
