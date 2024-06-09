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
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          (val) {
                            if (_formKey.currentState!.fields['inicio_trabajo']
                                    ?.value !=
                                null) {
                              if (val!.isBefore(_formKey.currentState!
                                  .fields['inicio_trabajo']?.value)) {
                                return 'La fecha de fin no puede ser anterior a la fecha de inicio';
                              }
                            }

                            return null;
                          }
                        ]),
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
                              : const Center(
                                  child: Text('No has agregado empleados')),
                        ),
                      ),
                      const SizedBox(height: 10),
                      MaterialButton(
                        color: Colors.amber,
                        onPressed: () {
                          if (_formKey.currentState!
                                  .validate(focusOnInvalid: false) &&
                              _listaEmpleadosSeleccionados.isNotEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Procesando')),
                            );
                            empleadosController.addWorkToEmployee(
                                empleados: _listaEmpleadosSeleccionados,
                                trabajo: {
                                  'descripcion': _formKey.currentState!
                                      .fields['descripcion']!.value,
                                  'fecha_inicio_trabajo': _formKey.currentState!
                                      .fields['inicio_trabajo']!.value,
                                  'fecha_final_trabajo': _formKey.currentState!
                                      .fields['fin_trabajo']!.value,
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
                          } else {
                            if (_listaEmpleadosSeleccionados.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Por favor agrege empleados al trabajo'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
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
  }

  void refreshNotifier(dynamic objTrabajador) {
    selectedTrabajador = objTrabajador;
  }

  @override
  void dispose() {
    _listaEmpleadosSeleccionados.clear();
    super.dispose();
  }
}
/*
 Flexible(
      child: SingleChildScrollView(
        child: Form(
          key: _formularioEstado,
          child: Column(
            children: [
              ValueListenableBuilder(
                valueListenable: _notifier,
                builder: (context, value, child) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey)),
                    child: Stack(
                      alignment: AlignmentDirectional.bottomEnd,
                      children: [
                        itemFormController['foto_nueva'].isNotEmpty
                            ? Image.file(File(itemFormController['foto_nueva']))
                            : widget.item['foto'] != null
                                ? Image.network(widget.item['foto'])
                                : Image.asset('assets/images/no-image.webp'),
                        IconButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amberAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              )),
                          icon: Icon(
                              widget.item['foto'] != null
                                  ? Icons.edit
                                  : Icons.add,
                              color: Colors.grey),
                          onPressed: () async {
                            await _selectImage();
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey)),
                  child: TextFormField(
                    controller: itemFormController['nombre'],
                    validator: (value) {
                      if (value!.isNotEmpty) {
                        return null; // todo ok
                      } else {
                        return 'Error en validacion'; // mal
                      }
                    },
                    decoration: InputDecoration(
                      hintText: widget.item['nombre'] ?? '',
                      border: InputBorder.none,
                      labelText: 'Nombre',
                    ),
                  )),
              const SizedBox(
                height: 10,
              ),
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey)),
                  child: TextFormField(
                    controller: itemFormController['cantidad'],
                    validator: (value) {
                      if (value!.isNotEmpty) {
                        return null; // todo ok
                      } else {
                        // return 'Error en validacion'; // mal
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      hintText: widget.item['cantidad']?.toString() ?? '',
                      border: InputBorder.none,
                      labelText: 'cantidad',
                    ),
                  )),
              const SizedBox(
                height: 10,
              ),
              Modular.to.path.toString().contains('editarItem')
                  ? //enseñar botones con logica para actualizar o eliminar empleado
                  EditDeleteItemButtonBar(
                      idItem: widget.idItem,
                      formularioEstado: _formularioEstado,
                      itemFormController: itemFormController,
                      refreshNotifier: refreshNotifier,
                    )
                  : NewItemButton(
                      formularioEstado: _formularioEstado,
                      refreshNotifier: refreshNotifier,
                      itemFormController: itemFormController,
                      item: widget.item)
            ],
          ),
        ),
      ),
    );
 */