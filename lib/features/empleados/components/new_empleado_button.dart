import 'package:ferret_erp/features/empleados/empleados_page.dart';
import 'package:flutter/material.dart';

class NewEmpleadoButton extends StatelessWidget {
  final GlobalKey<FormState> formularioEstado;
  final Map<String, TextEditingController> trabajadorFormController;
  final Function({String idTrabajador}) refreshNotifier;
  final Map<String, dynamic> empleado;

  const NewEmpleadoButton(
      {super.key,
      required this.formularioEstado,
      required this.refreshNotifier,
      required this.trabajadorFormController,
      required this.empleado});
  Map<String, dynamic> getFormData() {
    final res = <String, dynamic>{};

    for (MapEntry e in trabajadorFormController.entries) {
      res.putIfAbsent(e.key,
          () => e.value?.text.isNotEmpty ? e.value.text : empleado[e.key]);
    }
    return res;
  }

  Future<bool> _agregarEmpleado(formData) async {
    return await empleadosController.addEmpleado(formData);
  }

  @override
  Widget build(BuildContext context) {
    return ButtonBar(alignment: MainAxisAlignment.center, children: [
      ElevatedButton(
        onPressed: () {
          if (formularioEstado.currentState!.validate()) {
            formularioEstado.currentState!.save();
            final formData = getFormData();

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Procesando')),
            );

            _agregarEmpleado(formData).then((value) {
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
