import 'package:ferret_erp/features/empleados/empleados_controller.dart';
import 'package:flutter/material.dart';

class EmpleadoWorkTable extends StatefulWidget {
  final String trabajador;

  const EmpleadoWorkTable({super.key, required this.trabajador});

  @override
  State<EmpleadoWorkTable> createState() => _EmpleadoWorkTableState();
}

class _EmpleadoWorkTableState extends State<EmpleadoWorkTable> {
  final empleadosController = EmpleadosController();

  @override
  Widget build(BuildContext context) {
    print('ESTOY EN WORK TABLE');
    switch (widget.trabajador.isEmpty) {
      case true:
        return const Text('No hay datos');
      case false:
        return FutureBuilder(
            future: empleadosController.getEmpleadoTrabajos(
                empleadoId: widget.trabajador),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.data == null) return const Text('No hay datos');
                return _buildWorkTables(listaTrabajos: snapshot.data!);
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

  @override
  void dispose() {
    SnapshotController().dispose();
    super.dispose();
  }
}

Widget _buildWorkTables({required List<Map<String, dynamic>> listaTrabajos}) {
  return DataTable(
    columns: const [
      DataColumn(label: Text('Descripcion')),
      DataColumn(label: Text('Inicio')),
      DataColumn(label: Text('Final')),
      DataColumn(label: Text('Total Horas'))
    ],
    rows: listaTrabajos
        .map((trabajo) => _buildWorkTableRow(trabajo))
        .toList(), // Use map and _buildWorkTableRow function
  );
}

DataRow _buildWorkTableRow(Map<String, dynamic> trabajo) {
  String descripcion = trabajo['descripcion'] ?? '';
  String inicioTrabajo = trabajo['inicio_trabajo']?.toString() ?? '';
  String finalTrabajo = trabajo['final_trabajo']?.toString() ?? '';
  String totalHoras = trabajo['total_horas']?.toString() ?? '';

  return DataRow(cells: [
    DataCell(Text(descripcion)),
    DataCell(Text(inicioTrabajo)),
    DataCell(Text(finalTrabajo)),
    DataCell(Text(totalHoras)),
  ]);
}
