import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Guarda el JWT del usuario (Reto 2 - frontend).
///
/// Estrategia por plataforma (el enunciado admite ambos paquetes):
///  - Movil / escritorio: `flutter_secure_storage` -> almacenamiento cifrado.
///  - Web: `shared_preferences` -> en navegador `flutter_secure_storage`
///    tiene limitaciones, asi que usamos localStorage que siempre funciona.
class TokenStorage {
  static const _key = 'jwt_token';
  static const _secure = FlutterSecureStorage();

  static Future<void> save(String token) async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_key, token);
    } else {
      await _secure.write(key: _key, value: token);
    }
  }

  static Future<String?> read() async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_key);
    }
    return _secure.read(key: _key);
  }

  static Future<void> clear() async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_key);
    } else {
      await _secure.delete(key: _key);
    }
  }
}
