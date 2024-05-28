import 'package:ferret_erp/features/empleados/components/empleado_work_table.dart';
import 'package:ferret_erp/features/empleados/empleados_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class EmpleadosPage extends StatefulWidget {
  const EmpleadosPage({super.key});

  @override
  State<EmpleadosPage> createState() => _EmpleadosPageState();
}

List<Map<String, dynamic>> listaEmpleados = [];
String selectedTrabajador = "";
final empleadosController = EmpleadosController();
ValueNotifier<bool> _notifier = ValueNotifier(false);
int _currentIndex = 0;

List<Widget> listWidgets = [
  EmpleadoWorkTable(trabajador: selectedTrabajador),
  const Text('1')
];

class _EmpleadosPageState extends State<EmpleadosPage> {
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
                future: empleadosController.getEmpleadosIdAndName(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    listaEmpleados = snapshot.data!;
                    return Column(
                      children: [
                        _buildTrabajadorSelector(listaEmpleados),
                        ValueListenableBuilder(
                          valueListenable: _notifier,
                          builder: (context, value, child) {
                            return RouterOutlet();
                          },
                        )
                      ],
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
          ),
        ),
      ],
    );
  }

  Widget _buildTrabajadorSelector(List<Map<String, dynamic>> listaEmpleados) {
    return DropdownButtonFormField<String>(
      hint: const Text('Seleccione un trabajador'),
      items: listaEmpleados
          .map<DropdownMenuItem<String>>((empleado) => DropdownMenuItem<String>(
                value: empleado['id'],
                child: Text(empleado['nombre']),
              ))
          .toList(),
      onChanged: (value) {
        selectedTrabajador = value!;
        Modular.to.navigate('/empleados/tablaTrabajos/$selectedTrabajador');
        _notifier.value = !_notifier.value;
      },
    );
  }

  @override
  void dispose() {
    selectedTrabajador = ""; //reset selectedTrabajador
    super.dispose();
  }
}

class OptionMenu extends StatelessWidget {
  const OptionMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: Column(
        children: [
          ListTile(
            title: const Text('Información de empleado'),
            onTap: () {
              _currentIndex = 0;
              _notifier.value = !_notifier.value;
              Modular.to
                  .navigate('/empleados/tablaTrabajos/$selectedTrabajador');
            },
          ),
          ListTile(
            title: const Text('Trabajos'),
            onTap: () {
              _currentIndex = 1;
              _notifier.value = !_notifier.value;
            },
          ),
        ],
      ),
    );
  }
}
