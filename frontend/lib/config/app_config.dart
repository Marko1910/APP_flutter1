class AppConfig {
  // URL base de la API.
  //
  // Por defecto apunta a 10.0.2.2 que, desde el emulador de Android, es el
  // "localhost" de tu PC (donde corre el backend). Para web/escritorio usa
  // http://localhost:3000/api.
  //
  // En produccion (Reto 1) pasa la URL publica del backend en la nube:
  //   flutter run --dart-define=API_BASE_URL=https://tu-app.onrender.com/api
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:3000/api',
  );
}
