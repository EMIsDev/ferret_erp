import 'package:flutter/material.dart';

class EmpleadoDropdownSelector extends StatelessWidget {
  const EmpleadoDropdownSelector({
    super.key,
    required this.listaEmpleados,
    required this.refreshNotifier,
    this.selectedTrabajador,
  });
  final selectedTrabajador;
  final List<Map<String, dynamic>> listaEmpleados;
  final Function(dynamic) refreshNotifier;
  @override
  Widget build(BuildContext context) {
    print(selectedTrabajador);
    return DropdownButtonFormField<Map<String, dynamic>>(
      hint: const Text('Seleccione un trabajador'),
      value: selectedTrabajador,
      items: listaEmpleados
          .map<DropdownMenuItem<Map<String, dynamic>>>(
              (empleado) => DropdownMenuItem<Map<String, dynamic>>(
                    value: empleado,
                    child: Text(empleado['nombre']),
                  ))
          .toList(),
      onChanged: (value) {
        refreshNotifier(value!);
      },
    );
  }
}
