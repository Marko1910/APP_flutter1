import 'package:crud_withnodejs/models/empresa.dart';
import 'package:crud_withnodejs/providers/empresa_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FormScreen extends StatefulWidget {
  // Si llega una empresa, el formulario edita; si es null, crea una nueva.
  final Empresa? empresa;

  const FormScreen({super.key, this.empresa});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nombreCtrl;
  late final TextEditingController _rucCtrl;
  late final TextEditingController _direccionCtrl;
  late final TextEditingController _rubroCtrl;

  bool _saving = false;

  bool get _isEdit => widget.empresa != null;

  @override
  void initState() {
    super.initState();
    final e = widget.empresa;
    _nombreCtrl = TextEditingController(text: e?.nombre ?? '');
    _rucCtrl = TextEditingController(text: e?.ruc ?? '');
    _direccionCtrl = TextEditingController(text: e?.direccion ?? '');
    _rubroCtrl = TextEditingController(text: e?.rubro ?? '');
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _rucCtrl.dispose();
    _direccionCtrl.dispose();
    _rubroCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final empresa = Empresa(
      id: widget.empresa?.id,
      nombre: _nombreCtrl.text.trim(),
      ruc: _rucCtrl.text.trim(),
      direccion: _direccionCtrl.text.trim(),
      rubro: _rubroCtrl.text.trim(),
      esactivo: widget.empresa?.esactivo ?? true,
    );

    final provider = context.read<EmpresaProvider>();
    try {
      if (_isEdit) {
        await provider.update(widget.empresa!.id!, empresa);
      } else {
        await provider.add(empresa);
      }
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_isEdit ? 'Empresa actualizada' : 'Empresa creada')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEdit ? 'Editar Empresa' : 'Nueva Empresa')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nombreCtrl,
              decoration: const InputDecoration(
                labelText: 'Nombre',
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'El nombre es obligatorio' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _rucCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'RUC',
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'El RUC es obligatorio' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _direccionCtrl,
              decoration: const InputDecoration(
                labelText: 'Direccion',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _rubroCtrl,
              decoration: const InputDecoration(
                labelText: 'Rubro',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: _saving ? null : _save,
                child: _saving
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Guardar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
