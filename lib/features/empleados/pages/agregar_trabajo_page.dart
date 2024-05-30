import 'package:ferret_erp/features/empleados/components/empleado_dropdown_selector.dart';
import 'package:ferret_erp/features/empleados/empleados_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AgregarTrabajoPage extends StatefulWidget {
  const AgregarTrabajoPage({super.key});
  @override
  State<AgregarTrabajoPage> createState() => _AgregarTrabajoPageState();
}

class _AgregarTrabajoPageState extends State<AgregarTrabajoPage> {
  final _formKey = GlobalKey<FormState>(); // Form key for validation
  final _descripcionController =
      TextEditingController(); // Controller for description
  DateTime _selectedDateInicio = DateTime.now(); // Initial selected date
  DateTime _selectedDateFinal = DateTime.now(); // Initial selected date

  DateTime _horaInicio = DateTime.now(); // Initial time for work start
  DateTime _horaFinal =
      DateTime.now(); // Initial time for work endtial end date
  ValueNotifier<bool> _notifier = ValueNotifier(false);
  Map<String, dynamic> selectedTrabajador = {};
  List<Map<String, dynamic>> _listaEmpleados = [];
  List<Map<String, dynamic>> _listaEmpleadosSeleccionados = [];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: empleadosController.getEmpleadosIdAndName(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            _listaEmpleados = snapshot.data!;

            return Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: <Widget>[
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Descripción'),
                    controller: _descripcionController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese una descripción';
                      }
                      return null;
                    },
                  ),
                  ListTile(
                    title: Text(
                        'Fecha Inicio: ${DateFormat('dd/MM/yyyy').format(_selectedDateInicio)}'),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final selectedDate = await showDatePicker(
                        context: context,
                        initialDate: _selectedDateInicio,
                        firstDate:
                            DateTime.now().subtract(const Duration(days: 365)),
                        lastDate: DateTime.now(),
                        initialEntryMode: DatePickerEntryMode.input,
                      );
                      if (selectedDate != null) {
                        setState(() {
                          _selectedDateInicio = selectedDate;
                        });
                      }
                    },
                  ),
                  ListTile(
                    title: Text(
                        'Fecha Final: ${DateFormat('dd/MM/yyyy').format(_selectedDateFinal)}'),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final selectedDate = await showDatePicker(
                        context: context,
                        initialDate: _selectedDateFinal,
                        firstDate:
                            DateTime.now().subtract(const Duration(days: 365)),
                        lastDate: DateTime.now(),
                        initialEntryMode: DatePickerEntryMode.input,
                      );
                      if (selectedDate != null) {
                        setState(() {
                          _selectedDateFinal = selectedDate;
                        });
                      }
                    },
                  ),
                  Row(
                    children: [
                      const Text('Hora Inicio:'),
                      TextButton(
                        onPressed: () async {
                          final selectedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(_horaInicio),
                            initialEntryMode: TimePickerEntryMode.input,
                          );
                          if (selectedTime != null) {
                            setState(() {
                              _horaInicio = DateTime(
                                  _selectedDateInicio.year,
                                  _selectedDateInicio.month,
                                  _selectedDateInicio.day,
                                  selectedTime.hour,
                                  selectedTime.minute);
                            });
                          }
                        },
                        child: Text(
                            '${_horaInicio.hour.toString().padLeft(2, '0')}:${_horaInicio.minute.toString().padLeft(2, '0')}'),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text('Hora Final:'),
                      TextButton(
                        onPressed: () async {
                          final selectedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(_horaFinal),
                            initialEntryMode: TimePickerEntryMode.input,
                          );
                          if (selectedTime != null) {
                            setState(() {
                              _horaFinal = DateTime(
                                  _selectedDateInicio.year,
                                  _selectedDateInicio.month,
                                  _selectedDateInicio.day,
                                  selectedTime.hour,
                                  selectedTime.minute);
                            });
                          }
                        },
                        child: Text(
                            '${_horaFinal.hour.toString().padLeft(2, '0')}:${_horaFinal.minute.toString().padLeft(2, '0')}'),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: EmpleadoDropdownSelector(
                          listaEmpleados: _listaEmpleados,
                          refreshNotifier: refreshNotifier,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          if (selectedTrabajador.isNotEmpty) {
                            _listaEmpleadosSeleccionados
                                    .contains(selectedTrabajador)
                                ? null
                                : _listaEmpleadosSeleccionados
                                    .add(selectedTrabajador);
                            _notifier.value = !_notifier
                                .value; //notificar cambios en la lista para actualizar UI lista
                          }
                        },
                      ),
                    ],
                  ),
                  ValueListenableBuilder(
                    valueListenable: _notifier,
                    builder: (context, value, child) => Container(
                      height: 200,
                      color: Colors.grey[200],
                      child: _listaEmpleadosSeleccionados.isNotEmpty
                          ? SingleChildScrollView(
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: _listaEmpleadosSeleccionados.length,
                                itemBuilder: (context, index) {
                                  final item =
                                      _listaEmpleadosSeleccionados[index];
                                  return ListTile(
                                    title: Text(item['nombre']),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {
                                        _listaEmpleadosSeleccionados
                                            .removeAt(index);
                                        _notifier.value = !_notifier.value;
                                      },
                                    ),
                                  );
                                },
                              ),
                            )
                          : const Center(child: Text('No items')),
                    ),
                  ),
                  ElevatedButton(
                    child: const Text('Agregar Trabajo'),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await empleadosController.addWorkToEmployee(
                            empleados: _listaEmpleadosSeleccionados,
                            trabajo: {
                              'descripcion': _descripcionController.text,
                              'hora_inicio_trabajo': _horaInicio,
                              'hora_final_trabajo': _horaFinal,
                              'fecha_inicio': _selectedDateInicio,
                              'fecha_final': _selectedDateFinal,
                            });
                      }
                    },
                  ),
                ],
              ),
            );
          } else {
            return SizedBox(
              height: MediaQuery.of(context).size.height / 1.3,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }

  void refreshNotifier(dynamic objTrabajador) {
    selectedTrabajador = objTrabajador;
  }
}
