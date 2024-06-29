import 'package:empleados_module/models/empleados_model.dart';
import 'package:empleados_module/pages/agregar_empleado_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EditDeleteEmpleadoButtonBar extends StatelessWidget {
  final GlobalKey<FormState> formularioEstado;
  final Map<String, TextEditingController> trabajadorFormController;
  final Function({String idTrabajador}) refreshNotifier;
  final Empleado empleado;

  const EditDeleteEmpleadoButtonBar(
      {super.key,
      required this.formularioEstado,
      required this.refreshNotifier,
      required this.trabajadorFormController,
      required this.empleado});

  Map<String, dynamic> getFormData() {
    final res = <String, dynamic>{};
    Map<String, dynamic> empleadoMap = empleado.toJson();
    for (MapEntry e in trabajadorFormController.entries) {
      res.putIfAbsent(e.key,
          () => e.value?.text.isNotEmpty ? e.value.text : empleadoMap[e.key]);
    }
    res.putIfAbsent('id', () => empleado.id);
    return res;
  }

  Future<bool> _updateEmpleado({required Empleado updatedEmpleado}) async {
    return await empleadosController.updateEmpleado(
        updatedEmpleado: updatedEmpleado);
  }

  Future<bool> _deleteEmpleado(idTrabajado) async {
    return await empleadosController.deleteEmpleado(idTrabajado);
  }

  @override
  Widget build(BuildContext context) {
    return ButtonBar(alignment: MainAxisAlignment.center, children: [
      ElevatedButton(
        onPressed: () {
          if (formularioEstado.currentState!.validate()) {
            formularioEstado.currentState!.save();
            final Map<String, dynamic> formData = getFormData();
            Empleado updatedEmpleado = Empleado.fromJson(formData);

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Procesando')),
            );

            _updateEmpleado(updatedEmpleado: updatedEmpleado).then((value) {
              if (value) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Actualizado'),
                    backgroundColor: Colors.green,
                    onVisible: () {
                      refreshNotifier(idTrabajador: empleado.id);
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
                            context.pop();
                          },
                          child: const Text('No')),
                      ElevatedButton(
                        onPressed: () {
                          context.pop();
                          _deleteEmpleado(empleado.id).then((value) {
                            if (value) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Eliminado'),
                                  backgroundColor: Colors.green,
                                  onVisible: () {
                                    refreshNotifier();
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
                        },
                        child: const Text('Si'),
                      ),
                    ],
                  ),
              barrierDismissible: true);
        },
        child: const Text('Eliminar'),
      ),
    ]);
  }
}
