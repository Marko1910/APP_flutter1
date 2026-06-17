class AppConfig {
  // URL base de la API.
  //
  // Por defecto (Reto 1) apunta al backend desplegado en la nube (Render).
  // Asi la app funciona en cualquier dispositivo sin configuracion extra.
  //
  // Para desarrollo local puedes sobreescribirla con --dart-define:
  //   Web/escritorio: flutter run --dart-define=API_BASE_URL=http://localhost:3000/api
  //   Emulador Android: flutter run --dart-define=API_BASE_URL=http://10.0.2.2:3000/api
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://crud-empresas-api.onrender.com/api',
  );
}
