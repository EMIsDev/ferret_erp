import 'package:ferret_erp/features/empleados/components/empleado_autocomplete_search.dart';
import 'package:ferret_erp/features/empleados/empleados_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class AgregarTrabajoPage extends StatefulWidget {
  const AgregarTrabajoPage({super.key});
  @override
  State<AgregarTrabajoPage> createState() => _AgregarTrabajoPageState();
}

class _AgregarTrabajoPageState extends State<AgregarTrabajoPage> {
  final _formKey = GlobalKey<FormBuilderState>(); // Form key for validation
  /*final _descripcionController =
      TextEditingController(); // Controller for description
  DateTime _selectedDateInicio = DateTime.now(); // Initial selected date
  DateTime _selectedDateFinal = DateTime.now(); // Initial selected date

  DateTime _horaInicio = DateTime.now(); // Initial time for work start
  DateTime _horaFinal =
      DateTime.now(); // Initial time for work endtial end date
  final ValueNotifier<bool> _notifier = ValueNotifier(false);
  final ValueNotifier<DateTime> _horaFinalNotifier =
      ValueNotifier<DateTime>(DateTime.now());
  final ValueNotifier<DateTime> _horaInicioNotifier =
      ValueNotifier<DateTime>(DateTime.now());*/
  final ValueNotifier<bool> _notifier = ValueNotifier(false);

  Map<String, dynamic> selectedTrabajador = {};
  List<Map<String, dynamic>> _listaEmpleados = [];
  final List<Map<String, dynamic>> _listaEmpleadosSeleccionados = [];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: empleadosController.getEmpleadosIdAndName(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            _listaEmpleados = snapshot.data!;
            return Column(children: [
              Flexible(
                  child: SingleChildScrollView(
                child: FormBuilder(
                  key: _formKey,
                  child: Column(
                    children: [
                      FormBuilderTextField(
                        name: 'descripcion',
                        decoration:
                            const InputDecoration(labelText: 'Descripción'),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                        ]),
                      ),
                      const SizedBox(height: 10),
                      FormBuilderDateTimePicker(
                        name: 'inicio_trabajo',
                        firstDate: DateTime(1970),
                        lastDate: DateTime(2100),
                        initialEntryMode: DatePickerEntryMode.input,
                        decoration: const InputDecoration(
                            labelText: 'Inicio Trabajo',
                            icon: Icon(Icons.calendar_today)),
                        validator: FormBuilderValidators.compose(
                            [FormBuilderValidators.required()]),
                      ),
                      FormBuilderDateTimePicker(
                        name: 'fin_trabajo',
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1970),
                        lastDate: DateTime(2100),
                        inputType: InputType.both,
                        decoration: const InputDecoration(
                            labelText: 'Fin Trabajo',
                            icon: Icon(Icons.calendar_today)),
                        validator: FormBuilderValidators.compose(
                            [FormBuilderValidators.required()]),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: EmpleadoAutoCompleteSearch(
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
                                    itemCount:
                                        _listaEmpleadosSeleccionados.length,
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
                      const SizedBox(height: 10),
                      MaterialButton(
                        color: Colors.amber,
                        onPressed: () {
                          _formKey.currentState?.patchValue({
                            'descripcion': 'Navegacion',
                            'inicio_trabajo': DateTime(2024, 6, 9, 8),
                            'final_trabajo': DateTime(2024, 6, 9, 10),
                          });
                          _formKey.currentState?.saveAndValidate();
                          if (_formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Procesando')),
                            );
                            empleadosController.addWorkToEmployee(
                                empleados: _listaEmpleadosSeleccionados,
                                trabajo: {
                                  'descripcion': _formKey.currentState!
                                      .fields['descripcion']!.value,
                                  'hora_inicio_trabajo': _formKey.currentState!
                                      .fields['inicio_trabajo']!.value,
                                  'hora_final_trabajo': _formKey.currentState!
                                      .fields['final_trabajo']!.value,
                                }).then((value) {
                              if (value) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text('Actualizado'),
                                    backgroundColor: Colors.green,
                                    onVisible: () {
                                      setState(() {
                                        _formKey.currentState!.reset();

                                        /*_descripcionController.clear();
                                    _selectedDateInicio = DateTime.now();
                                    _selectedDateFinal = DateTime.now();
                                    _horaInicio = DateTime.now();
                                    _horaFinal = DateTime.now();*/
                                        _listaEmpleadosSeleccionados.clear();
                                        _notifier.value = !_notifier.value;
                                      });
                                    },
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Error'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            });
                          }

                          debugPrint(_formKey.currentState?.value.toString());
                        },
                        child: const Text('Agregar Trabajo'),
                      )
                    ],
                  ),
                ),
              )),
            ]);
          } else {
            return SizedBox(
              height: MediaQuery.of(context).size.height / 1.3,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
    /*Form(
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
                        _selectedDateInicio = selectedDate;
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
                        child: EmpleadoAutoCompleteSearch(
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
                        _formKey.currentState!.save();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Procesando')),
                        );
                        empleadosController.addWorkToEmployee(
                            empleados: _listaEmpleadosSeleccionados,
                            trabajo: {
                              'descripcion': _descripcionController.text,
                              'hora_inicio_trabajo': _horaInicio,
                              'hora_final_trabajo': _horaFinal,
                              'fecha_inicio': _selectedDateInicio,
                              'fecha_final': _selectedDateFinal,
                            }).then((value) {
                          if (value) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Actualizado'),
                                backgroundColor: Colors.green,
                                onVisible: () {
                                  setState(() {
                                    _formKey.currentState!.reset();

                                    _descripcionController.clear();
                                    _selectedDateInicio = DateTime.now();
                                    _selectedDateFinal = DateTime.now();
                                    _horaInicio = DateTime.now();
                                    _horaFinal = DateTime.now();
                                    _listaEmpleadosSeleccionados.clear();
                                    _notifier.value = !_notifier.value;
                                  });
                                },
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Error'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        });
                      }
                    },
                  ),
                ],
              ),
            );*/
  }

/*
  ElevatedButton(
                    child: const Text('Agregar Trabajo'),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Procesando')),
                        );
                        empleadosController.addWorkToEmployee(
                            empleados: _listaEmpleadosSeleccionados,
                            trabajo: {
                              'descripcion': _descripcionController.text,
                              'hora_inicio_trabajo': _horaInicio,
                              'hora_final_trabajo': _horaFinal,
                              'fecha_inicio': _selectedDateInicio,
                              'fecha_final': _selectedDateFinal,
                            }).then((value) {
                          if (value) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Actualizado'),
                                backgroundColor: Colors.green,
                                onVisible: () {
                                  setState(() {
                                    _formKey.currentState!.reset();

                                    _descripcionController.clear();
                                    _selectedDateInicio = DateTime.now();
                                    _selectedDateFinal = DateTime.now();
                                    _horaInicio = DateTime.now();
                                    _horaFinal = DateTime.now();
                                    _listaEmpleadosSeleccionados.clear();
                                    _notifier.value = !_notifier.value;
                                  });
                                },
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Error'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }); */
  void refreshNotifier(dynamic objTrabajador) {
    selectedTrabajador = objTrabajador;
  }

  @override
  void dispose() {
    _listaEmpleadosSeleccionados.clear();
    super.dispose();
  }
}
