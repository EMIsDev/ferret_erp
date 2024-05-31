import 'package:ferret_erp/features/empleados/empleados_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

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

  Future<bool> _updateEmpleado(formData) async {
    return await empleadosController.updateEmpleado(
        idTrabajador: widget.idTrabajador, updatedData: formData);
  }

  Future<bool> _deleteEmpleado(idTrabajado) async {
    return await empleadosController.deleteEmpleado(idTrabajado);
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
                          ButtonBar(
                              alignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    if (_formularioEstado.currentState!
                                        .validate()) {
                                      _formularioEstado.currentState!.save();
                                      final formData = getFormData();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text('Procesando')),
                                      );

                                      _updateEmpleado(formData).then((value) {
                                        if (value) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content:
                                                  const Text('Actualizado'),
                                              backgroundColor: Colors.green,
                                              onVisible: () {
                                                widget.refreshNotifier(
                                                    idTrabajador:
                                                        widget.idTrabajador);
                                              },
                                            ),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text('Error'),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        }
                                      });
                                    }
                                  },
                                  child: const Text('Actualizar'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                              title: const Text('ATENCIÓN!'),
                                              content: const Text(
                                                  'Seguro que quieres eliminar al trabajador?'),
                                              actions: [
                                                ElevatedButton(
                                                    onPressed: () {
                                                      Modular.to.pop();
                                                    },
                                                    child: const Text('No')),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    Modular.to.pop();
                                                    _deleteEmpleado(
                                                            widget.idTrabajador)
                                                        .then((value) {
                                                      if (value) {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          SnackBar(
                                                            content: const Text(
                                                                'Eliminado'),
                                                            backgroundColor:
                                                                Colors.green,
                                                            onVisible: () {
                                                              widget
                                                                  .refreshNotifier();
                                                            },
                                                          ),
                                                        );
                                                      } else {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          const SnackBar(
                                                            content:
                                                                Text('Error'),
                                                            backgroundColor:
                                                                Colors.red,
                                                          ),
                                                        );
                                                      }
                                                    });
                                                  },
                                                  child: const Text('Si'),
                                                ),
                                              ],
                                            ),
                                        barrierDismissible: true);
                                  },
                                  child: const Text('Eliminar'),
                                ),
                              ]),
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
