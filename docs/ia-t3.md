# Declaración de Uso de Inteligencia Artificial (Nivel 2)

| Asignatura | Desarrollo Móvil Integral |
| :--- | :--- |
| **Docente** | Ing. Maximiliano Carsi Castrejón |
| **Grupo** | 10.° C |
| **Actividad** | Tarea 3 de nivelación: Lista con tres estados |
| **Rama** | `feat/lista-tres-estados` |
| **Proyecto** | Gestor Cafetería (`gestor_cafeteria`) |

---

## 1. Herramienta y Versión
- **Herramienta de IA:** Antigravity (asistente de desarrollo basado en Gemini 3.8 Flash).
- **Modo de interacción:** Asistente contextual con acceso al código fuente local y ejecución controlada.

---

## 2. Prompts Principales Empleados

1. **Análisis de requerimientos:**
   > *"Revisa la guía de la Tarea 3 de nivelación (Lista con tres estados) y genera la clase sellada `Resultado<T>`, la entidad `Producto`, el repositorio falso y la pantalla con los tres estados cumpliendo Dart 3 y Material 3."*
2. **Generación de entidad y repositorio:**
   > *"Crea `Producto` con al menos 2 campos para la cafetería y `RepositorioFalso` que lance excepción en la llamada 1 y devuelva al menos 5 productos en la llamada 2 tras un delay de 2 segundos."*
3. **Generación de UI y pruebas:**
   > *"Crea `PantallaTresEstados` con `StatefulWidget`, `setState`, protección `if (!mounted) return;`, switch exhaustivo sin `default`, y pruebas automatizadas de widget que verifiquen los tres estados y el reintento."*

---

## 3. Registro de Decisiones: Qué se Aceptó, Qué se Modificó y Qué se Rechazó

* **Se aceptó:**
  * Uso de `sealed class Resultado<T>` con tres variantes (`Cargando`, `Exito`, `Error`), permitiendo coincidencia de patrones (*pattern matching*) exhaustiva en Dart 3 sin requerir `default`.
  * Contador interno `_llamadas` en `RepositorioFalso` para provocar el fallo deliberado en la primera solicitud y éxito con 5 productos reales en la segunda.
  * Uso estricto de `StatefulWidget` y `setState` sin librerías externas de gestión de estado (Provider, Riverpod, Bloc), respetando la restricción de la tarea.
* **Se modificó / ajustó:**
  * Se inyectó opcionalmente `RepositorioFalso? repositorio` en el constructor de `PantallaTresEstados` para permitir pasarle instancias simuladas o controladas en las pruebas de widget (`testWidgets`), manteniendo al mismo tiempo un valor por defecto para la ejecución normal de la app.
  * Se diseñaron las tarjetas (`Card`) con formato visual enriquecido: avatar circular con precio formateado (`$XX`), título destacado, descripción y categoría con chips de diseño Material 3.
* **Se rechazó:**
  * Se rechazó el uso de `catch (e)` que expusiera `e.toString()` directamente al usuario. En su lugar, el mensaje en el estado `Error` es 100% amigable y en español (`"No se pudo conectar con el servidor. Revisa tu conexión a internet."`), como exige la rúbrica.

---

## 4. Guía de Preparación para la Defensa Oral (Preguntas Clave)

### A. ¿Qué hace cada estado de `Resultado<T>` y por qué el `switch` no necesita `default`?
* **`Cargando<T>`:** Representa el momento en que la tarea asíncrona está en ejecución y la app espera los datos (muestra el `CircularProgressIndicator`).
* **`Exito<T>`:** Contiene los datos obtenidos de tipo `T` (en este caso `List<Producto>`) para renderizar el `ListView.builder`.
* **`Error<T>`:** Contiene un `String mensaje` claro y comprensible para mostrar al usuario la causa y ofrecer el botón de reintento.
* **¿Por qué no requiere `default`?:**
  Al definir `sealed class Resultado<T>`, el compilador de Dart 3 conoce de antemano todas las subclases directas posibles dentro de la misma biblioteca (`Cargando`, `Exito`, `Error`). Al realizar un `switch (_estado)`, el compilador verifica la **exhaustividad**: si cubres los tres casos, el `default` es innecesario y redundante. Si en el futuro se agrega un nuevo subtipo a `Resultado`, el compilador marcará un error en tiempo de compilación si no se maneja en el `switch`.

### B. ¿Cuál es el ciclo `setState` → `build` y para qué sirve `mounted`?
* **Ciclo `setState` → `build`:**
  Cuando se llama a `setState()`, se notifica al framework de Flutter que el estado interno del objeto `State` ha cambiado. Flutter marca el widget como "sucio" (*dirty*) y programa un nuevo fotograma en el que ejecuta el método `build(BuildContext context)` para reconstruir la interfaz reflejando el nuevo estado.
* **Para qué sirve `mounted`:**
  `mounted` es una propiedad booleana del `State` que indica si el widget está actualmente insertado en el árbol de widgets.
  Debido a que `_repositorio.obtener()` es una operación asíncrona (`await`) de 2 segundos, el usuario podría salir de la pantalla o cerrarla antes de que la respuesta llegue. Si llamamos a `setState()` cuando el widget ya fue destruido (desmontado del árbol), Flutter lanza una excepción: `setState() called after dispose()`.
  La instrucción `if (!mounted) return;` verifica si el widget sigue activo en pantalla; si no lo está, interrumpe la ejecución evitando fugas de memoria y errores en tiempo de ejecución.

---

## 5. Verificación y Pruebas Realizadas
1. **Pruebas unitarias:**
   * `test/core/resultado_test.dart`: Valida la instanciación, igualdad y exhaustividad del `switch`.
   * `test/data/repositorio_falso_test.dart`: Valida que la primera llamada arroje excepción y la segunda entregue 5 productos.
2. **Pruebas de widgets:**
   * `test/ui/pantalla_tres_estados_test.dart`: Simula el ciclo completo:
     - Estado 1: Muestra `CircularProgressIndicator`.
     - Estado 2: Falla a los 2 s y muestra mensaje de error con botón "Reintentar".
     - Estado 3: Pulsa "Reintentar", espera 2 s y comprueba que se rendericen las tarjetas de productos.
