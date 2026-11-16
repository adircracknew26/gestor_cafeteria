// IA: Clase sellada Resultado<T> para modelar los tres estados de una operación asíncrona.
// Utiliza la sintaxis de clases selladas de Dart 3 para garantizar coincidencia exhaustiva en switch.

sealed class Resultado<T> {
  const Resultado();
}

/// Estado inicial o durante la espera de datos asíncronos.
final class Cargando<T> extends Resultado<T> {
  const Cargando();

  @override
  bool operator ==(Object other) => identical(this, other) || other is Cargando<T>;

  @override
  int get hashCode => runtimeType.hashCode;
}

/// Estado exitoso que contiene los datos obtenidos.
final class Exito<T> extends Resultado<T> {
  const Exito(this.datos);

  final T datos;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Exito<T> && runtimeType == other.runtimeType && datos == other.datos;

  @override
  int get hashCode => datos.hashCode;
}

/// Estado de error que contiene un mensaje comprensible en español para el usuario.
final class Error<T> extends Resultado<T> {
  const Error(this.mensaje);

  final String mensaje;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Error<T> && runtimeType == other.runtimeType && mensaje == other.mensaje;

  @override
  int get hashCode => mensaje.hashCode;
}
