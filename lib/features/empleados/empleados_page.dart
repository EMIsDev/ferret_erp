import 'package:ferret_erp/features/empleados/components/empleado_work_table.dart';
import 'package:ferret_erp/features/empleados/empleados_controller.dart';
import 'package:flutter/material.dart';

class EmpleadosPage extends StatefulWidget {
  const EmpleadosPage({super.key});

  @override
  State<EmpleadosPage> createState() => _EmpleadosPageState();
}

List<Map<String, dynamic>> listaEmpleados = [];
String selectedTrabajador = "";
final empleadosController = EmpleadosController();
ValueNotifier<bool> _notifier = ValueNotifier(false);

class _EmpleadosPageState extends State<EmpleadosPage> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const OptionMenu(),
        Expanded(
          child: Column(
            children: [
              const Text('Empleado'),
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
                          },
                        )
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
          ),
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
      },
    );
  }

  @override
  void dispose() {
    selectedTrabajador = ""; //reset selectedTrabajador
    super.dispose();
  }
}

class TablaTrabajoEmpleado extends StatelessWidget {
  final String trabajador;

  const TablaTrabajoEmpleado({
    super.key,
    required this.trabajador,
  });

  @override
  Widget build(BuildContext context) {
    // Fetch data for the selected worker based on 'trabajador'
    // Implement your logic to fetch and display data specific to the worker

    return DataTable(
      columns: [
        const DataColumn(
          label: Expanded(
            child: Text(
              'Name',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
        const DataColumn(
          label: Expanded(
            child: Text(
              'Age',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
        const DataColumn(
          label: Expanded(
            child: Text(
              'Role',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
      ],
      rows: [],
    );
  }
}

class OptionMenu extends StatelessWidget {
  const OptionMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 200,
      child: Column(
        children: [
          Expanded(child: Placeholder()),
        ],
      ),
    );
  }
}
