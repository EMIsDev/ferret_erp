import 'package:ferret_erp/features/empleados/empleados_controller.dart';
import 'package:flutter/material.dart';

class EmpleadosPage extends StatefulWidget {
  const EmpleadosPage({super.key});

  @override
  State<EmpleadosPage> createState() => _EmpleadosPageState();
}

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
              FutureBuilder(
                future: empleadosController.getEmpleados(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    listaEmpleados = snapshot.data!;
                    return Column(
                      children: [
                        _buildTrabajadorSelector(listaEmpleados),
                        if (selectedTrabajador.isNotEmpty)
                          TablaTrabajoEmpleado(trabajador: selectedTrabajador),
                      ],
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTrabajadorSelector(List<dynamic> listaEmpleados) {
    //print(listaEmpleados.first['nombre']);
    // Extract worker names from listaEmpleados (assuming it contains names)
    List<String> workerNames =
        listaEmpleados.map((e) => e['nombre'] as String).toList();
    workerNames.map((e) => print(e));
    return DropdownButtonFormField<String>(
      items: workerNames
          .map((name) => DropdownMenuItem(
                value: name,
                child: Text(name),
              ))
          .toList(),
      onChanged: (value) {
        setState(() {
          selectedTrabajador = value!; // Update state on selection
        });
      },
    );
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

/*

class TablaTrabajoEmpleado extends StatelessWidget {
  const TablaTrabajoEmpleado({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: const <DataColumn>[
        DataColumn(
          label: Expanded(
            child: Text(
              'Name',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'Age',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'Role',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
      ],
      rows: const <DataRow>[
        DataRow(
          cells: <DataCell>[
            DataCell(Text('Sarah')),
            DataCell(Text('19')),
            DataCell(Text('Student')),
          ],
        ),
        DataRow(
          cells: <DataCell>[
            DataCell(Text('Janine')),
            DataCell(Text('43')),
            DataCell(Text('Professor')),
          ],
        ),
        DataRow(
          cells: <DataCell>[
            DataCell(Text('William')),
            DataCell(Text('27')),
            DataCell(Text('Associate Professor')),
          ],
        ),
      ],
    );
  }
}

*/
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
