import 'package:flutter/material.dart';
import 'service_form_page.dart';

class WorkshopFormPage extends StatefulWidget {
  const WorkshopFormPage({super.key});

  @override
  State<WorkshopFormPage> createState() => _WorkshopFormPageState();
}

class _WorkshopFormPageState extends State<WorkshopFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _openCtrl = TextEditingController(text: '08:00');
  final _closeCtrl = TextEditingController(text: '18:00');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Formulario Taller')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Nombre del taller'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Requerido' : null,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _openCtrl,
                      decoration: const InputDecoration(labelText: 'Hora apertura (HH:mm)'),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Requerido' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _closeCtrl,
                      decoration: const InputDecoration(labelText: 'Hora cierre (HH:mm)'),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Requerido' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Guardar y agregar servicios'),
                onPressed: () {
                  if (!_formKey.currentState!.validate()) return;

                  final workshopId = DateTime.now().millisecondsSinceEpoch.toString(); // ID simulado
                  final schedule = {
                    'open': _openCtrl.text,
                    'close': _closeCtrl.text,
                  };

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ServiceFormPage(
                        workshopId: workshopId,
                        workshopName: _nameCtrl.text,
                        schedule: schedule,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
