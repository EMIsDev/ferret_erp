import 'package:ferret_erp/features/empleados/empleados_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class EmpleadosPage extends StatefulWidget {
  const EmpleadosPage({super.key});

  @override
  State<EmpleadosPage> createState() => _EmpleadosPageState();
}

List<Map<String, dynamic>> listaEmpleados = [];
final empleadosController = EmpleadosController();

class _EmpleadosPageState extends State<EmpleadosPage> {
  @override
  Widget build(BuildContext context) {
    //print(Modular.routerDelegate.currentConfiguration?.routes);
    return const RouterOutlet();
  }
}
