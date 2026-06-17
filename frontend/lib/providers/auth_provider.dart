import 'package:crud_withnodejs/models/usuario.dart';
import 'package:crud_withnodejs/services/api_services.dart';
import 'package:crud_withnodejs/services/token_storage.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  Usuario? _usuario;
  Usuario? get usuario => _usuario;

  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  // Mientras se revisa si ya hay un token guardado en el dispositivo.
  bool _initializing = true;
  bool get initializing => _initializing;

  bool _loading = false;
  bool get loading => _loading;

  AuthProvider() {
    _tryAutoLogin();
  }

  /// Al arrancar la app, si hay un token guardado, entra directo.
  Future<void> _tryAutoLogin() async {
    final token = await TokenStorage.read();
    _isAuthenticated = token != null && token.isNotEmpty;
    _initializing = false;
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    _loading = true;
    notifyListeners();
    try {
      final result = await ApiService.login(email, password);
      await TokenStorage.save(result.token);
      _usuario = result.usuario;
      _isAuthenticated = true;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> register(String nombre, String email, String password) async {
    _loading = true;
    notifyListeners();
    try {
      final result = await ApiService.register(nombre, email, password);
      await TokenStorage.save(result.token);
      _usuario = result.usuario;
      _isAuthenticated = true;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await TokenStorage.clear();
    _usuario = null;
    _isAuthenticated = false;
    notifyListeners();
  }
}
