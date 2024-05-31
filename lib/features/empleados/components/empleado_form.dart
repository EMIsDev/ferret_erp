import 'package:ferret_erp/features/empleados/components/edit_delete_empleado_buttons.dart';
import 'package:ferret_erp/features/empleados/empleados_controller.dart';
import 'package:flutter/material.dart';

class EmpleadoForm extends StatefulWidget {
  final String idTrabajador;
  final Function({String idTrabajador}) refreshNotifier;

  const EmpleadoForm({
    super.key,
    required this.idTrabajador,
    required this.refreshNotifier,
  });

  @override
  State<EmpleadoForm> createState() => _EmpleadoFormState();
}

class _EmpleadoFormState extends State<EmpleadoForm> {
  final empleadosController = EmpleadosController();
  final GlobalKey<FormState> _formularioEstado = GlobalKey<FormState>();
  Map<String, dynamic> empleado = {};
  final Map<String, TextEditingController> trabajadorFormController = {
    'nombre': TextEditingController(),
    'apellido': TextEditingController(),
    'telefono': TextEditingController()
  };

  Map<String, dynamic> getFormData() {
    final res = <String, dynamic>{};

    for (MapEntry e in trabajadorFormController.entries) {
      res.putIfAbsent(e.key,
          () => e.value?.text.isNotEmpty ? e.value.text : empleado[e.key]);
    }
    return res;
  }

  void _populateFormFields() {
    for (MapEntry e in trabajadorFormController.entries) {
      trabajadorFormController[e.key]!.text = empleado[e.key].toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.idTrabajador.isEmpty) {
      case true:
        return const Text('No hay datos');
      case false:
        return FutureBuilder(
            future: empleadosController.getEmpleadoById(
                empleadoId: widget.idTrabajador),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.data == null) return const Text('No hay datos');
                empleado = snapshot.data as Map<String, dynamic>;
                _populateFormFields();
                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Form(
                      key: _formularioEstado,
                      child: Column(
                        children: [
                          Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.grey)),
                              child: TextFormField(
                                controller: trabajadorFormController['nombre'],
                                validator: (value) {
                                  if (value!.isNotEmpty) {
                                    return null; // todo ok
                                  } else {
                                    return 'Error en validacion'; // mal
                                  }
                                },
                                decoration: InputDecoration(
                                  hintText: '${empleado['nombre']}',
                                  border: InputBorder.none,
                                  labelText: 'Nombre',
                                ),
                              )),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.grey)),
                              child: TextFormField(
                                controller:
                                    trabajadorFormController['apellido'],
                                validator: (value) {
                                  if (value!.isNotEmpty) {
                                    return null; // todo ok
                                  } else {
                                    // return 'Error en validacion'; // mal
                                    return null;
                                  }
                                },
                                decoration: InputDecoration(
                                  hintText: '${empleado['apellido']}',
                                  border: InputBorder.none,
                                  labelText: 'apellido',
                                ),
                              )),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.grey)),
                              child: TextFormField(
                                controller:
                                    trabajadorFormController['telefono'],
                                validator: (value) {
                                  if (value!.isNotEmpty) {
                                    return null; // todo ok
                                  } else {
                                    // return 'Error en validacion'; // mal
                                    return null;
                                  }
                                },
                                decoration: InputDecoration(
                                  hintText: '${empleado['telefono']}',
                                  border: InputBorder.none,
                                  labelText: 'telefono',
                                ),
                              )),
                          EditDeleteEmpleadoButtonBar(
                              idTrabajador: widget.idTrabajador,
                              formularioEstado: _formularioEstado,
                              refreshNotifier: widget.refreshNotifier,
                              trabajadorFormController:
                                  trabajadorFormController,
                              empleado: empleado)
                        ],
                      )),
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
  }
}
