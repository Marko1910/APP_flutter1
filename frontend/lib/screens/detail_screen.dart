import 'package:crud_withnodejs/models/empresa.dart';
import 'package:crud_withnodejs/providers/empleado_provider.dart';
import 'package:crud_withnodejs/providers/empresa_provider.dart';
import 'package:crud_withnodejs/screens/empleado_form_screen.dart';
import 'package:crud_withnodejs/screens/form_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailScreen extends StatefulWidget {
  final Empresa empresa;

  const DetailScreen({super.key, required this.empresa});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadEmpleados());
  }

  Future<void> _loadEmpleados() async {
    try {
      await context.read<EmpleadoProvider>().load(widget.empresa.id!);
    } catch (e) {
      _showSnack(e.toString(), error: true);
    }
  }

  void _showSnack(String msg, {bool error = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: error ? Colors.red : null),
    );
  }

  Future<void> _deleteEmpresa() async {
    final empresaProvider = context.read<EmpresaProvider>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar empresa'),
        content: Text('¿Eliminar "${widget.empresa.nombre}" y sus empleados?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await empresaProvider.remove(widget.empresa.id!);
      if (!mounted) return;
      Navigator.pop(context); // vuelve a la lista
    } catch (e) {
      _showSnack(e.toString(), error: true);
    }
  }

  void _addEmpleado() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EmpleadoFormScreen(empresaId: widget.empresa.id!),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final empresa = widget.empresa;
    final empleadoProvider = context.watch<EmpleadoProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de la Empresa')),
      floatingActionButton: FloatingActionButton.extended(
        // Reto 3: registrar empleado asignado al id de ESTA empresa.
        onPressed: _addEmpleado,
        icon: const Icon(Icons.person_add),
        label: const Text('Empleado'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(empresa.nombre,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('RUC: ${empresa.ruc}'),
                  const SizedBox(height: 4),
                  Text('Direccion: ${empresa.direccion ?? "-"}'),
                  const SizedBox(height: 4),
                  Text('Rubro: ${empresa.rubro ?? "-"}'),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => FormScreen(empresa: empresa),
                          ),
                        ),
                        icon: const Icon(Icons.edit),
                        label: const Text('Editar'),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        onPressed: _deleteEmpresa,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red),
                        icon: const Icon(Icons.delete, color: Colors.white),
                        label: const Text('Eliminar',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Empleados',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          if (empleadoProvider.isLoading)
            const Center(child: Padding(
              padding: EdgeInsets.all(24),
              child: CircularProgressIndicator(),
            ))
          else if (empleadoProvider.empleados.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('Aun no hay empleados registrados.'),
            )
          else
            ...empleadoProvider.empleados.map(
              (emp) => Card(
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.person)),
                  title: Text(emp.nombre),
                  subtitle: Text(emp.cargo ?? 'Sin cargo'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () async {
                      try {
                        await context.read<EmpleadoProvider>().remove(emp.id!);
                        _showSnack('Empleado eliminado');
                      } catch (e) {
                        _showSnack(e.toString(), error: true);
                      }
                    },
                  ),
                ),
              ),
            ),
          const SizedBox(height: 80), // espacio para que el FAB no tape la lista
        ],
      ),
    );
  }
}
