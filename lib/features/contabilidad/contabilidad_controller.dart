import 'package:ferret_erp/features/empleados/empleados_controller.dart';
import 'package:flutter/material.dart';

class _EmpleadosPageState extends State<EmpleadosPage> {
  final empleadosController = EmpleadosController();
  List<dynamic> listaEmpleados = [];
  String selectedTrabajador = "";

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const OptionMenu(),
        Expanded(
            child: Column(
          children: [
            const Text('Empleado'),
            _buildTrabajadorSelector(listaEmpleados),
            FutureBuilder(
                future: empleadosController.getEmpleados(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    listaEmpleados = snapshot.data!;
                    TablaTrabajoEmpleado(trabajador: selectedTrabajador);
                  } else {
                    return const CircularProgressIndicator();
                  }
                })
          ],
        )),
      ],
    );
  }
}
