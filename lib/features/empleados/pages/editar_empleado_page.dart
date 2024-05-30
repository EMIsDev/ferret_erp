import 'package:ferret_erp/features/empleados/components/empleado_form.dart';
import 'package:ferret_erp/features/empleados/empleados_controller.dart';
import 'package:flutter/material.dart';

import '../components/empleado_dropdown_selector.dart';

class EditarEmpleado extends StatefulWidget {
  const EditarEmpleado({super.key});

  @override
  State<EditarEmpleado> createState() => _EditarEmpleadoState();
}

List<Map<String, dynamic>> listaEmpleados = [];
String selectedTrabajador = "";
final empleadosController = EmpleadosController();
ValueNotifier<bool> _notifier = ValueNotifier(false);

class _EditarEmpleadoState extends State<EditarEmpleado> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder(
          future: empleadosController.getEmpleadosIdAndName(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              listaEmpleados = snapshot.data!;
              return Column(
                children: [
                  EmpleadoDropdownSelector(
                      listaEmpleados: listaEmpleados,
                      refreshNotifier: refreshNotifier),
                  ValueListenableBuilder(
                      valueListenable: _notifier,
                      builder: (context, value, child) {
                        if (selectedTrabajador.isNotEmpty) {
                          return EmpleadoForm(trabajador: selectedTrabajador);
                        } else {
                          return const SizedBox();
                        }
                      }),
                ],
              );
            } else {
              return SizedBox(
                height: MediaQuery.of(context).size.height / 1.3,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
        ),
      ],
    );
  }

  void refreshNotifier(dynamic idTrabajador) {
    selectedTrabajador = idTrabajador['id'];
    _notifier.value = !_notifier.value;
  }

  @override
  void dispose() {
    selectedTrabajador = ""; //reset selectedTrabajador
    super.dispose();
  }
}
