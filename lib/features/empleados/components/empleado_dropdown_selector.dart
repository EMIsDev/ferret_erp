import 'package:flutter/material.dart';

class EmpleadoDropdownSelector extends StatelessWidget {
  const EmpleadoDropdownSelector({
    super.key,
    required this.listaEmpleados,
    required this.refreshNotifier,
  });

  final List<Map<String, dynamic>> listaEmpleados;
  final Function(String) refreshNotifier;
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      hint: const Text('Seleccione un trabajador'),
      items: listaEmpleados
          .map<DropdownMenuItem<String>>((empleado) => DropdownMenuItem<String>(
                value: empleado['id'],
                child: Text(empleado['nombre']),
              ))
          .toList(),
      onChanged: (value) {
        refreshNotifier(value!);
      },
    );
  }
}
