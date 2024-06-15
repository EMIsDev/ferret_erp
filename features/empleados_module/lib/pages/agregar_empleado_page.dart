import 'package:empleados_module/components/empleado_form.dart';
import 'package:empleados_module/empleados_controller.dart';
import 'package:flutter/material.dart';

class AgregarEmpleadoPage extends StatefulWidget {
  const AgregarEmpleadoPage({super.key});

  @override
  State<AgregarEmpleadoPage> createState() => _AgregarEmpleadoPageState();
}

List<Map<String, dynamic>> listaEmpleados = [];
String selectedTrabajador = "";
final empleadosController = EmpleadosController();

class _AgregarEmpleadoPageState extends State<AgregarEmpleadoPage> {
  @override
  Widget build(BuildContext context) {
    return EmpleadoForm(refreshNotifier: refreshDropDown);
  }

  void refreshDropDown({String idTrabajador = ''}) {
    setState(() {
      selectedTrabajador = idTrabajador;
    });
  }

  @override
  void dispose() {
    selectedTrabajador = ""; //reset selectedTrabajador
    super.dispose();
  }
}
