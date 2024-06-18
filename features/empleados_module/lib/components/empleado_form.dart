import 'package:empleados_module/components/edit_delete_empleado_buttons.dart';
import 'package:empleados_module/components/new_empleado_button.dart';
import 'package:empleados_module/controllers/empleados_controller.dart';
import 'package:empleados_module/models/empleados_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EmpleadoForm extends StatefulWidget {
  final Empleado empleado;
  final Function({String idTrabajador}) refreshNotifier;
  EmpleadoForm({
    super.key,
    required this.refreshNotifier,
    Empleado? empleado,
  }) : empleado = empleado ?? Empleado.empty();
  @override
  State<EmpleadoForm> createState() => _EmpleadoFormState();
}

class _EmpleadoFormState extends State<EmpleadoForm> {
  final empleadosController = EmpleadosController();
  final GlobalKey<FormState> _formularioEstado = GlobalKey<FormState>();
  final Map<String, TextEditingController> trabajadorFormController = {
    'nombre': TextEditingController(),
    'apellido': TextEditingController(),
    'telefono': TextEditingController()
  };

  void _populateFormFields() {
    Map<String, dynamic> empleadoMap = widget.empleado.toJson();
    for (MapEntry e in trabajadorFormController.entries) {
      trabajadorFormController[e.key]!.text = empleadoMap[e.key].toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.empleado.id.isNotEmpty) {
      //si hay datos en el empleado, rellenar los campos
      _populateFormFields();
    }

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Form(
        key: _formularioEstado,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey),
              ),
              child: TextFormField(
                controller: trabajadorFormController['nombre'],
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Error campo vacío';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: widget.empleado.nombre,
                  border: InputBorder.none,
                  labelText: 'Nombre',
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey),
              ),
              child: TextFormField(
                controller: trabajadorFormController['apellido'],
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Error campo vacío';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: widget.empleado.apellido,
                  border: InputBorder.none,
                  labelText: 'Apellido',
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey),
              ),
              child: TextFormField(
                controller: trabajadorFormController['telefono'],
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Error campo vacío';
                  }
                  if (int.tryParse(value) == null) {
                    if (double.tryParse(value) == null) {
                      return 'Error campo tiene que ser un número';
                    }
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: widget.empleado.telefono,
                  border: InputBorder.none,
                  labelText: 'Telefono',
                ),
              ),
            ),
            GoRouter.of(context)
                    .routeInformationProvider
                    .value
                    .uri
                    .toString()
                    .contains('editarEmpleado')
                ? EditDeleteEmpleadoButtonBar(
                    formularioEstado: _formularioEstado,
                    refreshNotifier: widget.refreshNotifier,
                    trabajadorFormController: trabajadorFormController,
                    empleado: widget.empleado)
                : NewEmpleadoButton(
                    formularioEstado: _formularioEstado,
                    refreshNotifier: widget.refreshNotifier,
                    trabajadorFormController: trabajadorFormController,
                    empleado: widget.empleado),
          ],
        ),
      ),
    );
  }
}
