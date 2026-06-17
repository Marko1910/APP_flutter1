import 'package:crud_withnodejs/models/empresa.dart';
import 'package:crud_withnodejs/services/api_services.dart';
import 'package:flutter/material.dart';

class EmpresaProvider with ChangeNotifier {
  // Lista completa traida del backend.
  List<Empresa> _all = [];

  // Texto de busqueda (Reto 4): se filtra localmente para respuesta instantanea.
  String _query = '';
  String get query => _query;

  /// Lista visible: si hay busqueda, filtra por nombre o RUC.
  List<Empresa> get empresas {
    if (_query.isEmpty) return _all;
    final q = _query.toLowerCase();
    return _all
        .where((e) =>
            e.nombre.toLowerCase().contains(q) ||
            e.ruc.toLowerCase().contains(q))
        .toList();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void search(String value) {
    _query = value;
    notifyListeners();
  }

  void _setLoading(bool v) {
    _isLoading = v;
    notifyListeners();
  }

  /// Carga la lista. Relanza el error para que la pantalla muestre un SnackBar.
  Future<void> load() async {
    _setLoading(true);
    try {
      _all = await ApiService.getEmpresas();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> add(Empresa e) async {
    final nuevo = await ApiService.createEmpresa(e);
    _all.add(nuevo);
    notifyListeners();
  }

  Future<void> update(int id, Empresa e) async {
    final updated = await ApiService.updateEmpresa(id, e);
    final i = _all.indexWhere((x) => x.id == id);
    if (i != -1) _all[i] = updated;
    notifyListeners();
  }

  Future<void> remove(int id) async {
    await ApiService.deleteEmpresa(id);
    _all.removeWhere((x) => x.id == id);
    notifyListeners();
  }
}
