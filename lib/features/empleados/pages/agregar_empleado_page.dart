import 'package:ferret_erp/features/empleados/components/empleado_form.dart';
import 'package:ferret_erp/features/empleados/empleados_controller.dart';
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
    return Column(
      children: [
        FutureBuilder(
          future: empleadosController.getEmpleadosIdAndName(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              listaEmpleados = snapshot.data!;
              return Column(
                children: [
                  EmpleadoForm(refreshNotifier: refreshDropDown)
                ], // ver de como hacer para no tener que pasar un refreshNotifier que no sirve de nada en este caso
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
    );
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
