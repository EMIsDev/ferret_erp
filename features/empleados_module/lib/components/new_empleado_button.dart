import 'package:empleados_module/models/empleados_model.dart';
import 'package:empleados_module/pages/agregar_empleado_page.dart';
import 'package:flutter/material.dart';

class NewEmpleadoButton extends StatelessWidget {
  final GlobalKey<FormState> formularioEstado;
  final Map<String, TextEditingController> trabajadorFormController;
  final Function({String idTrabajador}) refreshNotifier;

  const NewEmpleadoButton({
    super.key,
    required this.formularioEstado,
    required this.refreshNotifier,
    required this.trabajadorFormController,
  });
  Map<String, dynamic> getFormData() {
    final res = <String, dynamic>{};

    for (MapEntry e in trabajadorFormController.entries) {
      res.putIfAbsent(
          e.key, () => e.value?.text.isNotEmpty ? e.value.text : '');
    }
    return res;
  }

  Future<bool> _agregarEmpleado({required Empleado newEmpleado}) async {
    return await empleadosController.addEmpleado(newEmpleado);
  }

  @override
  Widget build(BuildContext context) {
    return ButtonBar(alignment: MainAxisAlignment.center, children: [
      ElevatedButton(
        onPressed: () {
          if (formularioEstado.currentState!.validate()) {
            formularioEstado.currentState!.save();
            final Map<String, dynamic> formData = getFormData();
            Empleado newEmpleado = Empleado.fromJson(formData);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Procesando')),
            );

            _agregarEmpleado(newEmpleado: newEmpleado).then((value) {
              if (value) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Actualizado'),
                    backgroundColor: Colors.green,
                    onVisible: () {
                      refreshNotifier();
                      //Navigator.of(context).pushReplacementNamed(
                      //'/empleados/agregarTrabajo', // agregar ruta a info empleado directamente
                      //);
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
        child: const Text('Agregar empleado'),
      )
    ]);
  }
}
