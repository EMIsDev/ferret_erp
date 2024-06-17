import 'package:empleados_module/components/empleado_autocomplete_search.dart';
import 'package:empleados_module/components/empleado_work_table.dart';
import 'package:empleados_module/controllers/empleados_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';

class HistorialTrabajo extends StatefulWidget {
  const HistorialTrabajo({super.key});

  @override
  State<HistorialTrabajo> createState() => _HistorialTrabajoState();
}

class _HistorialTrabajoState extends State<HistorialTrabajo> {
  List<Map<String, dynamic>> listaEmpleados = [];
  String selectedTrabajador = "";
  final empleadosController = EmpleadosController();
  ValueNotifier<bool> _notifier = ValueNotifier(false);
  Map<String, dynamic> filters = {'rango_trabajo': null};
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          FutureBuilder(
            future: empleadosController.getEmpleadosIdAndName(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                listaEmpleados = snapshot.data ?? [];
                return Column(mainAxisSize: MainAxisSize.max, children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        flex: 2,
                        child: EmpleadoAutoCompleteSearch(
                          listaEmpleados: listaEmpleados,
                          refreshNotifier: refreshNotifier,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 1,
                        child: FormBuilder(
                          key: _formKey,
                          child: FormBuilderDateRangePicker(
                            name: 'rango_trabajo',
                            firstDate: DateTime(1970),
                            lastDate: DateTime(2100),
                            format: DateFormat('dd-MM-yyyy'),
                            initialEntryMode: DatePickerEntryMode.input,
                            decoration: const InputDecoration(
                              labelText: 'Rango de Trabajo',
                              icon: Icon(Icons.calendar_today),
                            ),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                            ]),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 1,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!
                                .saveAndValidate(focusOnInvalid: false)) {
                              filters['rango_trabajo'] =
                                  _formKey.currentState!.value['rango_trabajo'];
                              _notifier.value = !_notifier.value;
                            }
                          },
                          child: const Text('Buscar'),
                        ),
                      ),
                    ],
                  ),
                ]);
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
          ValueListenableBuilder<bool>(
            valueListenable: _notifier,
            builder: (context, value, child) {
              if (selectedTrabajador.isNotEmpty) {
                return EmpleadoWorkTable(
                  trabajadorId: selectedTrabajador,
                  filtersTrabajo: filters,
                );
              } else {
                return const SizedBox();
              }
            },
          ),
        ],
      ),
    );
  }

  void refreshNotifier(dynamic idTrabajador) {
    selectedTrabajador = idTrabajador['id'];
    //  _notifier.value = !_notifier.value;
  }

  @override
  void dispose() {
    selectedTrabajador = ""; // reset selectedTrabajador
    super.dispose();
  }
}
