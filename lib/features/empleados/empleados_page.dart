import 'package:ferret_erp/main_module.dart';
import 'package:flutter/material.dart';

class EmpleadosPage extends StatelessWidget {
  const EmpleadosPage({super.key});

  @override
  Widget build(BuildContext context) {
    MainModule().moduleRoutes.forEach((element) {
      print(element.name);
    });
    return  const Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text('Empleados'),
        Icon(Icons.people),
      ],
    );
  }
}
