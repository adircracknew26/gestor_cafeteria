// IA: Pantalla con tres estados controlada mediante la clase sellada Resultado<T>.
// Implementada estrictamente con StatefulWidget y setState, cumpliendo Material 3 y switch exhaustivo.

import 'package:flutter/material.dart';
import '../core/resultado.dart';
import '../data/repositorio_falso.dart';
import '../domain/producto.dart';

class PantallaTresEstados extends StatefulWidget {
  const PantallaTresEstados({
    super.key,
    this.repositorio,
  });

  final RepositorioFalso? repositorio;

  @override
  State<PantallaTresEstados> createState() => _PantallaTresEstadosState();
}

class _PantallaTresEstadosState extends State<PantallaTresEstados> {
  late final RepositorioFalso _repositorio;
  Resultado<List<Producto>> _estado = const Cargando();

  @override
  void initState() {
    super.initState();
    _repositorio = widget.repositorio ?? RepositorioFalso();
    _cargarProductos();
  }

  /// Carga los datos de manera asíncrona.
  /// Protege las actualizaciones de estado con if (!mounted) return tras el await.
  Future<void> _cargarProductos() async {
    setState(() {
      _estado = const Cargando();
    });

    try {
      final productos = await _repositorio.obtener();
      if (!mounted) return;
      setState(() {
        _estado = Exito(productos);
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _estado = const Error('No se pudo conectar con el servidor. Revisa tu conexión a internet.');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menú de Cafetería'),
        centerTitle: true,
      ),
      // IA: Switch exhaustivo sobre la clase sellada Resultado (sin cláusula default)
      body: switch (_estado) {
        Cargando() => const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text(
                  'Cargando productos...',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
        Exito(datos: final productos) => ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: productos.length,
            itemBuilder: (context, index) {
              final producto = productos[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
                    child: Text(
                      '\$${producto.precio.toStringAsFixed(0)}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Text(
                    producto.nombre,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(producto.descripcion),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceVariant,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            producto.categoria,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  isThreeLine: true,
                ),
              );
            },
          ),
        Error(mensaje: final mensaje) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    size: 64,
                    color: Colors.redAccent,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    mensaje,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: _cargarProductos,
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Reintentar'),
                  ),
                ],
              ),
            ),
          ),
      },
    );
  }
}
