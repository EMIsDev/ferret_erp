import 'package:empleados_module/controllers/empleados_controller.dart';
import 'package:empleados_module/models/trabajos_model.dart';
import 'package:flutter/material.dart';

class EmpleadoWorkTable extends StatefulWidget {
  final String trabajadorId;
  final Map<String, dynamic> filtersTrabajo;
  const EmpleadoWorkTable(
      {super.key, required this.trabajadorId, required this.filtersTrabajo});

  @override
  State<EmpleadoWorkTable> createState() => _EmpleadoWorkTableState();
}

class _EmpleadoWorkTableState extends State<EmpleadoWorkTable> {
  final empleadosController = EmpleadosController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: empleadosController.getEmpleadoTrabajos(
          empleadoId: widget.trabajadorId, filters: widget.filtersTrabajo),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          List<Trabajo> listaTrabajos = snapshot.data ?? [];
          print(listaTrabajos);
          if (listaTrabajos.isEmpty) {
            return const Center(
              child: Text('No hay datos'),
            );
          }

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Descripción')),
                DataColumn(label: Text('Inicio')),
                DataColumn(label: Text('Final')),
                DataColumn(label: Text('Total Horas')),
              ],
              rows: listaTrabajos
                  .map((trabajo) => _buildWorkTableRow(trabajo))
                  .toList(),
            ),
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
    );
  }

  DataRow _buildWorkTableRow(Trabajo trabajo) {
    String descripcion = trabajo.descripcion;
    String inicioTrabajo = trabajo.inicioTrabajo.toString();
    String finalTrabajo = trabajo.finalTrabajo.toString();
    String totalHoras = trabajo.horasTrabajadas?.toString() ?? '';

    return DataRow(cells: [
      DataCell(Text(descripcion)),
      DataCell(Text(inicioTrabajo)),
      DataCell(Text(finalTrabajo)),
      DataCell(Text(totalHoras)),
    ]);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
