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
    switch (widget.trabajador.isEmpty) {
      case true:
        return const Text('No hay datos');
      case false:
        return FutureBuilder(
            future: empleadosController.getEmpleadoById(
                empleadoId: widget.trabajador),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.data == null) return const Text('No hay datos');
                Map<String, dynamic> empleado =
                    snapshot.data as Map<String, dynamic>;
                return Text(empleado['nombre']);
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
}

/*  return FutureBuilder(
        future:
            empleadosController.getEmpleadoById(empleadoId: widget.trabajador),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == null) return const Text('No hay datos');
            Map<String, dynamic> empleado =
                snapshot.data as Map<String, dynamic>;
            return Text(empleado['nombre']);
          } else {
            return SizedBox(
              height: MediaQuery.of(context).size.height / 1.3,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });*/