import 'package:ferret_erp/features/empleados/empleados_controller.dart';
import 'package:flutter/material.dart';

class EmpleadoInfoCard extends StatefulWidget {
  final String trabajador;

  const EmpleadoInfoCard({super.key, required this.trabajador});

  @override
  State<EmpleadoInfoCard> createState() => _EmpleadoInfoCardState();
}

class _EmpleadoInfoCardState extends State<EmpleadoInfoCard> {
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
                return _buildEmpleadoInfoCard(empleado: empleado);
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

  Widget _buildEmpleadoInfoCard({required Map<String, dynamic> empleado}) {
    return Card(
      child: SizedBox(
        height: 100,
        child: Center(
          child: ListTile(
            leading:
                IconButton(onPressed: () {}, icon: const Icon(Icons.person)),
            title: Text('${empleado['nombre']}'),
            subtitle: Text('${empleado['apellido']}'),
            trailing:
                OutlinedButton(onPressed: () {}, child: const Icon(Icons.edit)),
          ),
        ),
      ),
    );
  }
}
