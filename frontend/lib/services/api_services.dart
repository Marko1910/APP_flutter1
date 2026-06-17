import 'dart:convert';

import 'package:crud_withnodejs/config/app_config.dart';
import 'package:crud_withnodejs/models/empleado.dart';
import 'package:crud_withnodejs/models/empresa.dart';
import 'package:crud_withnodejs/models/usuario.dart';
import 'package:crud_withnodejs/services/token_storage.dart';
import 'package:http/http.dart' as http;

/// Excepcion con un mensaje legible para mostrar al usuario en un SnackBar.
class ApiException implements Exception {
  final String message;
  ApiException(this.message);
  @override
  String toString() => message;
}

class ApiService {
  static const _base = AppConfig.apiBaseUrl;

  /// Arma los headers; si [auth] es true agrega el token JWT (Reto 2 - el puente).
  static Future<Map<String, String>> _headers({bool auth = true}) async {
    final headers = {"Content-Type": "application/json"};
    if (auth) {
      final token = await TokenStorage.read();
      if (token != null && token.isNotEmpty) {
        headers["Authorization"] = "Bearer $token";
      }
    }
    return headers;
  }

  /// Ejecuta una peticion y convierte fallos de red en un ApiException claro.
  static Future<http.Response> _request(
      Future<http.Response> Function() fn) async {
    try {
      return await fn();
    } on ApiException {
      rethrow;
    } catch (_) {
      throw ApiException(
          'No se pudo conectar con el servidor. Revisa tu conexion a internet.');
    }
  }

  /// Extrae el mensaje de error que devuelve el backend ({ "error": "..." }).
  static String _errorMessage(http.Response res, String fallback) {
    try {
      final body = jsonDecode(res.body);
      if (body is Map && body['error'] != null) return body['error'].toString();
    } catch (_) {}
    return fallback;
  }

  // ----------------------- AUTENTICACION -----------------------

  static Future<AuthResult> login(String email, String password) async {
    final res = await _request(() async => http.post(
          Uri.parse('$_base/auth/login'),
          headers: await _headers(auth: false),
          body: jsonEncode({"email": email, "password": password}),
        ));
    if (res.statusCode == 200) {
      return AuthResult.fromJson(jsonDecode(res.body));
    }
    throw ApiException(_errorMessage(res, 'No se pudo iniciar sesion'));
  }

  static Future<AuthResult> register(
      String nombre, String email, String password) async {
    final res = await _request(() async => http.post(
          Uri.parse('$_base/auth/register'),
          headers: await _headers(auth: false),
          body: jsonEncode(
              {"nombre": nombre, "email": email, "password": password}),
        ));
    if (res.statusCode == 200 || res.statusCode == 201) {
      return AuthResult.fromJson(jsonDecode(res.body));
    }
    throw ApiException(_errorMessage(res, 'No se pudo registrar el usuario'));
  }

  // ------------------------- EMPRESAS -------------------------

  static Future<List<Empresa>> getEmpresas({String? search}) async {
    final uri = Uri.parse('$_base/empresas').replace(
      queryParameters: (search != null && search.isNotEmpty)
          ? {"search": search}
          : null,
    );
    final res = await _request(() async => http.get(uri, headers: await _headers()));
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => Empresa.fromJson(e)).toList();
    }
    throw ApiException(_errorMessage(res, 'Error al listar empresas'));
  }

  static Future<Empresa> createEmpresa(Empresa e) async {
    final res = await _request(() async => http.post(
          Uri.parse('$_base/empresas'),
          headers: await _headers(),
          body: jsonEncode(e.toJson()),
        ));
    if (res.statusCode == 200 || res.statusCode == 201) {
      return Empresa.fromJson(jsonDecode(res.body));
    }
    throw ApiException(_errorMessage(res, 'Error al crear empresa'));
  }

  static Future<Empresa> updateEmpresa(int id, Empresa e) async {
    final res = await _request(() async => http.put(
          Uri.parse('$_base/empresas/$id'),
          headers: await _headers(),
          body: jsonEncode(e.toJson()),
        ));
    if (res.statusCode == 200) {
      return Empresa.fromJson(jsonDecode(res.body));
    }
    throw ApiException(_errorMessage(res, 'Error al actualizar empresa'));
  }

  static Future<void> deleteEmpresa(int id) async {
    final res = await _request(() async => http.delete(
          Uri.parse('$_base/empresas/$id'),
          headers: await _headers(),
        ));
    if (res.statusCode != 200) {
      throw ApiException(_errorMessage(res, 'Error al eliminar empresa'));
    }
  }

  // ------------------------- EMPLEADOS -------------------------

  static Future<List<Empleado>> getEmpleados(int empresaId) async {
    final res = await _request(() async => http.get(
          Uri.parse('$_base/empresas/$empresaId/empleados'),
          headers: await _headers(),
        ));
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => Empleado.fromJson(e)).toList();
    }
    throw ApiException(_errorMessage(res, 'Error al listar empleados'));
  }

  static Future<Empleado> createEmpleado(int empresaId, Empleado e) async {
    final res = await _request(() async => http.post(
          Uri.parse('$_base/empresas/$empresaId/empleados'),
          headers: await _headers(),
          body: jsonEncode(e.toJson()),
        ));
    if (res.statusCode == 200 || res.statusCode == 201) {
      return Empleado.fromJson(jsonDecode(res.body));
    }
    throw ApiException(_errorMessage(res, 'Error al crear empleado'));
  }

  static Future<void> deleteEmpleado(int id) async {
    final res = await _request(() async => http.delete(
          Uri.parse('$_base/empleados/$id'),
          headers: await _headers(),
        ));
    if (res.statusCode != 200) {
      throw ApiException(_errorMessage(res, 'Error al eliminar empleado'));
    }
  }
}
