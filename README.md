# Gestor Cafetería ☕📱

Cliente móvil desarrollado en Flutter para la gestión y seguimiento de pedidos de una cafetería, conectado a una API REST backend (`mini_backend`).

Este proyecto forma parte de la asignatura **Desarrollo Móvil Integral** e implementa arquitectura limpia, mapeo robusto de errores HTTP a tipos de fallos fuertemente tipados (`Failure`), consumo de servicios en la nube y pruebas unitarias automatizadas con clientes simulados (`MockClient`).

---

## 📋 Requisitos Previos

- **Flutter SDK:** 3.18.0 o superior (Dart SDK >= 3.0.0 < 4.0.0)
- **Node.js:** 22.13 o superior (`node --version`)
- **Git**
- Emulador Android, dispositivo físico o Google Chrome para ejecución web

---

## 🖥️ Backend de Pruebas (mini_backend)

El proyecto se comunica con el servidor de pedidos [mini_backend](https://github.com/DMI-2026/mini_backend).

- **Repositorio oficial:** [https://github.com/DMI-2026/mini_backend](https://github.com/DMI-2026/mini_backend)
- **Versión/Commit probado:** `94d2533` (rama `master`)

### Cómo levantar el backend:
1. Clona o descarga el repositorio fuera de este proyecto:
   ```bash
   git clone https://github.com/DMI-2026/mini_backend.git
   cd mini_backend
   ```
2. Inicia el servidor (no requiere `npm install`, usa módulos nativos de Node.js):
   ```bash
   node server.js
   ```
   Deberás ver el mensaje `Listening on ...:8000`.
3. Comprueba el estado en tu navegador: [http://localhost:8000/health](http://localhost:8000/health) (debe responder `{"status":"ok"}`).

---

## 🚀 Cómo ejecutar la aplicación móvil

Dentro de la carpeta `gestor_cafeteria`:

1. Instala las dependencias:
   ```bash
   flutter pub get
   ```

2. Ejecuta según tu entorno:

- **En Google Chrome (Web):**
  ```bash
  flutter run -d chrome
  ```
- **En Emulador de Android:**
  ```bash
  flutter run
  ```
  *(Utiliza automáticamente la IP `10.0.2.2:8000` para comunicarse con la máquina anfitriona).*
- **En Teléfono Físico (misma red Wi-Fi):**
  ```bash
  flutter run --dart-define=API_URL=http://<IP_DE_TU_COMPUTADORA>:8000
  ```

---

## 🧪 Cómo correr las pruebas automatizadas

Para verificar el análisis estático y la suite de pruebas unitarias:

```bash
# 1. Análisis estático (calidad de código sin advertencias)
flutter analyze

# 2. Pruebas unitarias completas
flutter test
```

---

## 📂 Estructura del Proyecto

```text
gestor_cafeteria/
├── lib/
│   ├── core/
│   │   ├── failure.dart      # Jerarquía sellada de fallos (NetworkFailure, ServerFailure, etc.)
│   │   └── http_client.dart  # Cliente HTTP desacoplado con mapeo tipado de errores
│   └── main.dart             # Punto de entrada de la aplicación Flutter
├── test/
│   └── core/
│       ├── failure_test.dart      # Pruebas unitarias de la jerarquía de Failure
│       └── http_client_test.dart  # Pruebas unitarias de ApiClient con MockClient
├── pubspec.yaml              # Dependencias y configuración de Flutter
└── README.md                 # Documentación técnica del proyecto
```
