import 'package:ferret_erp/features/empleados/components/empleado_work_table.dart';
import 'package:ferret_erp/features/empleados/empleados_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class HistorialTrabajo extends StatefulWidget {
  const HistorialTrabajo({super.key});

  @override
  State<HistorialTrabajo> createState() => _HistorialTrabajoState();
}

List<Map<String, dynamic>> listaEmpleados = [];
String selectedTrabajador = "";
final empleadosController = EmpleadosController();
ValueNotifier<bool> _notifier = ValueNotifier(false);

class _HistorialTrabajoState extends State<HistorialTrabajo> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder(
          future: empleadosController.getEmpleadosIdAndName(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              listaEmpleados = snapshot.data!;
              return Column(
                children: [
                  _buildTrabajadorSelector(listaEmpleados),
                  ValueListenableBuilder(
                      valueListenable: _notifier,
                      builder: (context, value, child) {
                        return EmpleadoWorkTable(
                            trabajador: selectedTrabajador);
                      }),
                ],
              );
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
      ],
    );
  }

  Widget _buildTrabajadorSelector(List<Map<String, dynamic>> listaEmpleados) {
    return DropdownButtonFormField<String>(
      hint: const Text('Seleccione un trabajador'),
      items: listaEmpleados
          .map<DropdownMenuItem<String>>((empleado) => DropdownMenuItem<String>(
                value: empleado['id'],
                child: Text(empleado['nombre']),
              ))
          .toList(),
      onChanged: (value) {
        selectedTrabajador = value!;
        _notifier.value = !_notifier.value;

        //Coger ruta actual sin args para navegar en ella con el nuevo valor de selectedTrabajador
        /*  String rutaActual = Modular.to.path;
        int lastSlashIndex = rutaActual.lastIndexOf('/');
        String rootPath = rutaActual.substring(0, lastSlashIndex + 1);
        Modular.to.navigate(rootPath + selectedTrabajador);*/
      },
    );
  }

  @override
  void dispose() {
    selectedTrabajador = ""; //reset selectedTrabajador
    super.dispose();
  }
}

class OptionMenu extends StatelessWidget {
  const OptionMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: Column(
        children: [
          ListTile(
            title: const Text('Información de empleado'),
            onTap: () {
              Modular.to.navigate('/empleados/info/$selectedTrabajador');
            },
          ),
          ListTile(
            title: const Text('Trabajos'),
            onTap: () {
              Modular.to
                  .navigate('/empleados/tablaTrabajos/$selectedTrabajador');
            },
          ),
        ],
      ),
    );
  }
}
