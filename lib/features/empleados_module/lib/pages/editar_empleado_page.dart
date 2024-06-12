import 'package:empleados_module/components/empleado_form.dart';
import 'package:empleados_module/empleados_controller.dart';
import 'package:flutter/material.dart';

import '../components/empleado_autocomplete_search.dart';

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
                  EmpleadoAutoCompleteSearch(
                      listaEmpleados: listaEmpleados,
                      refreshNotifier: refreshNotifier,
                      selectedTrabajador: selectedTrabajador),
                  ValueListenableBuilder(
                      valueListenable: _notifier,
                      builder: (context, value, child) {
                        if (selectedTrabajador.isNotEmpty) {
                          return FutureBuilder(
                            future: empleadosController.getEmpleadoById(
                                empleadoId: selectedTrabajador),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                if (snapshot.data == null) {
                                  return const Text('No hay datos');
                                }
                                final empleado =
                                    snapshot.data as Map<String, dynamic>;
                                empleado.addEntries([
                                  MapEntry('id', selectedTrabajador),
                                ]);
                                return SingleChildScrollView(
                                  child: EmpleadoForm(
                                      refreshNotifier: refreshDropDown,
                                      empleado: empleado),
                                );
                              } else {
                                return const SizedBox(
                                  height: 200,
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }
                            },
                          );
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

  void refreshDropDown({String idTrabajador = ''}) {
    setState(() {
      selectedTrabajador = idTrabajador;
    });
  }

  @override
  void dispose() {
    selectedTrabajador = ""; //reset selectedTrabajador
    super.dispose();
  }
}
