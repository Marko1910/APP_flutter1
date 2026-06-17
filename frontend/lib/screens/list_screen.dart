import 'package:crud_withnodejs/models/empresa.dart';
import 'package:crud_withnodejs/providers/auth_provider.dart';
import 'package:crud_withnodejs/providers/empresa_provider.dart';
import 'package:crud_withnodejs/screens/detail_screen.dart';
import 'package:crud_withnodejs/screens/form_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  /// Carga la lista y, si falla, muestra un SnackBar rojo (Reto 4 - Alertas).
  Future<void> _load() async {
    try {
      await context.read<EmpresaProvider>().load();
    } catch (e) {
      _showSnack(e.toString(), error: true);
    }
  }

  void _showSnack(String msg, {bool error = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: error ? Colors.red : null,
      ),
    );
  }

  Future<bool> _confirmDelete(String nombre) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar eliminacion'),
        content: Text('¿Estas seguro que deseas eliminar "$nombre"?'),
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
    return result ?? false;
  }

  Future<void> _delete(Empresa empresa) async {
    try {
      await context.read<EmpresaProvider>().remove(empresa.id!);
      _showSnack('"${empresa.nombre}" eliminada');
    } catch (e) {
      _showSnack(e.toString(), error: true);
      await _load(); // recarga para restaurar el item si la eliminacion fallo
    }
  }

  void _openForm({Empresa? empresa}) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => FormScreen(empresa: empresa)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EmpresaProvider>();
    final empresas = provider.empresas;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Empresas',
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            tooltip: 'Cerrar sesion',
            icon: const Icon(Icons.logout),
            onPressed: () => context.read<AuthProvider>().logout(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          // Barra de busqueda (Reto 4): filtra por nombre o RUC.
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar por nombre o RUC...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) => provider.search(value),
            ),
          ),
          Expanded(
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    // Pull to refresh (Reto 4): arrastra hacia abajo para recargar.
                    onRefresh: _load,
                    child: empresas.isEmpty
                        ? ListView(
                            // ListView para que el RefreshIndicator funcione aun vacio.
                            children: const [
                              SizedBox(height: 120),
                              Center(child: Text('No hay empresas para mostrar')),
                            ],
                          )
                        : ListView.builder(
                            itemCount: empresas.length,
                            itemBuilder: (context, index) {
                              final empresa = empresas[index];
                              return Dismissible(
                                key: ValueKey(empresa.id),
                                // Deslizar en cualquier direccion (como Gmail).
                                direction: DismissDirection.horizontal,
                                background: _swipeBg(Alignment.centerLeft),
                                secondaryBackground:
                                    _swipeBg(Alignment.centerRight),
                                confirmDismiss: (_) =>
                                    _confirmDelete(empresa.nombre),
                                onDismissed: (_) => _delete(empresa),
                                child: Card(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 4),
                                  child: ListTile(
                                    title: Text(empresa.nombre),
                                    subtitle: Text('RUC: ${empresa.ruc}'),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () =>
                                          _openForm(empresa: empresa),
                                    ),
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            DetailScreen(empresa: empresa),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _swipeBg(Alignment alignment) => Container(
        color: Colors.red,
        alignment: alignment,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: const Icon(Icons.delete, color: Colors.white),
      );
}
