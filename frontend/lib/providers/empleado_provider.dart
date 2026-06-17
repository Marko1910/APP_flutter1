import 'package:crud_withnodejs/models/empleado.dart';
import 'package:crud_withnodejs/services/api_services.dart';
import 'package:flutter/material.dart';

class EmpleadoProvider with ChangeNotifier {
  List<Empleado> _empleados = [];
  List<Empleado> get empleados => _empleados;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void _setLoading(bool v) {
    _isLoading = v;
    notifyListeners();
  }

  Future<void> load(int empresaId) async {
    _setLoading(true);
    try {
      _empleados = await ApiService.getEmpleados(empresaId);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> add(int empresaId, Empleado e) async {
    final nuevo = await ApiService.createEmpleado(empresaId, e);
    _empleados.add(nuevo);
    notifyListeners();
  }

  Future<void> remove(int id) async {
    await ApiService.deleteEmpleado(id);
    _empleados.removeWhere((x) => x.id == id);
    notifyListeners();
  }
}
