import 'package:empleados_module/components/empleado_work_table.dart';
import 'package:empleados_module/empleados_controller.dart';
import 'package:flutter/material.dart';

import '../components/empleado_autocomplete_search.dart';

class HistorialTrabajo extends StatefulWidget {
  const HistorialTrabajo({super.key});

  @override
  State<HistorialTrabajo> createState() => _HistorialTrabajoState();
}

List<Map<String, dynamic>> listaEmpleados = [];
String selectedTrabajador = "";
final empleadosController = EmpleadosController();
ValueNotifier<bool> _notifier = ValueNotifier(false);

class _HistorialTrabajoState extends State<HistorialTrabajo> {
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
                  EmpleadoAutoCompleteSearch(
                      listaEmpleados: listaEmpleados,
                      refreshNotifier: refreshNotifier),
                  ValueListenableBuilder(
                      valueListenable: _notifier,
                      builder: (context, value, child) {
                        if (selectedTrabajador.isNotEmpty) {
                          return EmpleadoWorkTable(
                              trabajadorId: selectedTrabajador);
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