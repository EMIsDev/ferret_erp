import 'package:empleados_module/controllers/empleados_controller.dart';
import 'package:empleados_module/models/trabajos_model.dart';
import 'package:flutter/material.dart';

class EmpleadoWorkTable extends StatefulWidget {
  final String trabajadorId;
  final Map<String, dynamic> filtersTrabajo;

  const EmpleadoWorkTable({
    Key? key,
    required this.trabajadorId,
    required this.filtersTrabajo,
  }) : super(key: key);

  @override
  State<EmpleadoWorkTable> createState() => _EmpleadoWorkTableState();
}

class _EmpleadoWorkTableState extends State<EmpleadoWorkTable> {
  final empleadosController = EmpleadosController();
  final ScrollController _horizontalScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Trabajo>?>(
      future: empleadosController.getEmpleadoTrabajos(
        empleadoId: widget.trabajadorId,
        filters: widget.filtersTrabajo,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          List<Trabajo> listaTrabajos = snapshot.data ?? [];
          if (listaTrabajos.isEmpty) {
            return const Center(
              child: Text('No hay datos'),
            );
          }

          // Calcular el total de horas trabajadas
          Duration totalHorasTrabajadas = Duration.zero;
          for (var trabajo in listaTrabajos) {
            totalHorasTrabajadas += trabajo.horasTrabajadas ?? const Duration();
          }

          // Crear las filas de la tabla
          List<DataRow> rows = listaTrabajos
              .map((trabajo) => _buildWorkTableRow(trabajo))
              .toList();

          // Agregar la última fila con el total de horas trabajadas
          rows.add(DataRow(
              color: WidgetStateProperty.all(Colors.black.withOpacity(0.1)),
              cells: [
                const DataCell(Text('Total Horas',
                    style: TextStyle(fontWeight: FontWeight.bold))),
                const DataCell(Text('')),
                const DataCell(Text('')),
                DataCell(
                  Text('${_formatDuration(totalHorasTrabajadas)}h',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                )
              ]));

          return Scrollbar(
            controller: _horizontalScrollController,
            thumbVisibility: true,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              controller: _horizontalScrollController,
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(Colors.amber[200]),
                columns: const [
                  DataColumn(label: Text('Descripción')),
                  DataColumn(label: Text('Inicio')),
                  DataColumn(label: Text('Final')),
                  DataColumn(label: Text('Total Horas')),
                ],
                rows: rows,
              ),
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
    return DataRow(cells: [
      DataCell(
        ConstrainedBox(
          constraints: BoxConstraints(minHeight: 50, maxWidth: 200),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Text(trabajo.descripcion),
          ),
        ),
      ),
      DataCell(Text(trabajo.formattedInicioTrabajo)),
      DataCell(Text(trabajo.formattedFinalTrabajo)),
      DataCell(Text('${trabajo.formattedHorasTrabajadas}h')),
    ]);
  }

  String _formatDuration(Duration duration) {
    return '${duration.inHours}:${(duration.inMinutes.remainder(60)).toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    super.dispose();
  }
}
