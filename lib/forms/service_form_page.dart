import 'package:flutter/material.dart';

class ServiceFormPage extends StatefulWidget {
  final String workshopId;
  final String workshopName;
  final Map<String, String> schedule;

  const ServiceFormPage({
    super.key,
    required this.workshopId,
    required this.workshopName,
    required this.schedule,
  });

  @override
  State<ServiceFormPage> createState() => _ServiceFormPageState();
}

class _ServiceFormPageState extends State<ServiceFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _desc = TextEditingController();
  final _category = TextEditingController(text: 'mantenimiento');
  final _price = TextEditingController();
  final _minutes = TextEditingController(text: '30');

  final List<Map<String, dynamic>> _services = [];

  void _addService() {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _services.add({
        'name': _name.text.trim(),
        'description': _desc.text.trim(),
        'category': _category.text.trim(),
        'basePrice': double.parse(_price.text),
        'estimatedMinutes': int.parse(_minutes.text),
      });
      _name.clear();
      _desc.clear();
      _price.clear();
      _minutes.text = '30';
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Servicio agregado (local)')));
  }

  void _finish() {
    // Aquí podrías enviar todo a Firebase. Por ahora solo mostramos un resumen.
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Resumen'),
        content: SingleChildScrollView(
          child: Text(
            'Taller: ${widget.workshopName}\n'
            'Horario: ${widget.schedule['open']} - ${widget.schedule['close']}\n'
            'Servicios: ${_services.length}\n\n'
            '${_services.map((s) => '• ${s['name']} (\$${s['basePrice']}, ${s['estimatedMinutes']} min)').join('\n')}',
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cerrar')),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // dialog
              Navigator.popUntil(context, (r) => r.isFirst); // volver al Home
            },
            child: const Text('Listo'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Servicios de "${widget.workshopName}"'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(30),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              'Horario: ${widget.schedule['open']} - ${widget.schedule['close']}  |  ID: ${widget.workshopId}',
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Formulario de servicio
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _name,
                    decoration: const InputDecoration(labelText: 'Nombre del servicio'),
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Requerido' : null,
                  ),
                  TextFormField(
                    controller: _desc,
                    decoration: const InputDecoration(labelText: 'Descripción'),
                    maxLines: 2,
                  ),
                  TextFormField(
                    controller: _category,
                    decoration: const InputDecoration(labelText: 'Categoría'),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _price,
                          decoration: const InputDecoration(labelText: 'Precio (USD)'),
                          keyboardType: TextInputType.number,
                          validator: (v) =>
                              (v == null || double.tryParse(v) == null) ? 'Número válido' : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _minutes,
                          decoration: const InputDecoration(labelText: 'Minutos'),
                          keyboardType: TextInputType.number,
                          validator: (v) =>
                              (v == null || int.tryParse(v) == null) ? 'Entero válido' : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: _addService,
                        icon: const Icon(Icons.add),
                        label: const Text('Agregar servicio'),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton.icon(
                        onPressed: _services.isEmpty ? null : _finish,
                        icon: const Icon(Icons.check),
                        label: const Text('Finalizar'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Divider(),
            // Lista de servicios agregados
            Expanded(
              child: _services.isEmpty
                  ? const Center(child: Text('Sin servicios aún'))
                  : ListView.separated(
                      itemCount: _services.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (_, i) {
                        final s = _services[i];
                        return ListTile(
                          title: Text(s['name']),
                          subtitle: Text('${s['category']} • ${s['estimatedMinutes']} min'),
                          trailing: Text('\$${s['basePrice']}'),
                          onLongPress: () {
                            setState(() => _services.removeAt(i));
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
