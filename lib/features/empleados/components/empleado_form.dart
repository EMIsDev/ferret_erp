import 'package:ferret_erp/features/empleados/components/edit_delete_empleado_buttons.dart';
import 'package:ferret_erp/features/empleados/components/new_empleado_button.dart';
import 'package:ferret_erp/features/empleados/empleados_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class EmpleadoForm extends StatefulWidget {
  final Map<String, dynamic> empleado;
  final Function({String idTrabajador}) refreshNotifier;

  const EmpleadoForm({
    super.key,
    required this.refreshNotifier,
    this.empleado = const {},
  });

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

  Map<String, dynamic> getFormData() {
    final res = <String, dynamic>{};

    for (MapEntry e in trabajadorFormController.entries) {
      res.putIfAbsent(
          e.key,
          () =>
              e.value?.text.isNotEmpty ? e.value.text : widget.empleado[e.key]);
    }
    return res;
  }

  void _populateFormFields() {
    for (MapEntry e in trabajadorFormController.entries) {
      trabajadorFormController[e.key]!.text = widget.empleado[e.key].toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.empleado.isNotEmpty) {
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
                      border: Border.all(color: Colors.grey)),
                  child: TextFormField(
                    controller: trabajadorFormController['nombre'],
                    validator: (value) {
                      if (value!.isNotEmpty) {
                        return null; // todo ok
                      } else {
                        return 'Error en validacion'; // mal
                      }
                    },
                    decoration: InputDecoration(
                      hintText: widget.empleado['nombre'] ?? '',
                      border: InputBorder.none,
                      labelText: 'Nombre',
                    ),
                  )),
              const SizedBox(
                height: 10,
              ),
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey)),
                  child: TextFormField(
                    controller: trabajadorFormController['apellido'],
                    validator: (value) {
                      if (value!.isNotEmpty) {
                        return null; // todo ok
                      } else {
                        // return 'Error en validacion'; // mal
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      hintText: widget.empleado['apellido'] ?? '',
                      border: InputBorder.none,
                      labelText: 'apellido',
                    ),
                  )),
              const SizedBox(
                height: 10,
              ),
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey)),
                  child: TextFormField(
                    controller: trabajadorFormController['telefono'],
                    validator: (value) {
                      if (value!.isNotEmpty) {
                        return null; // todo ok
                      } else {
                        // return 'Error en validacion'; // mal
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      hintText: widget.empleado['telefono'] ?? '',
                      border: InputBorder.none,
                      labelText: 'telefono',
                    ),
                  )),
              Modular.to.path.toString().contains('editarEmpleado')
                  ? //enseñar botones con logica para actualizar o eliminar empleado
                  EditDeleteEmpleadoButtonBar(
                      idTrabajador: widget.empleado['id'],
                      formularioEstado: _formularioEstado,
                      refreshNotifier: widget.refreshNotifier,
                      trabajadorFormController: trabajadorFormController,
                      empleado: widget.empleado)
                  : NewEmpleadoButton(
                      formularioEstado: _formularioEstado,
                      refreshNotifier: widget.refreshNotifier,
                      trabajadorFormController: trabajadorFormController,
                      empleado: widget.empleado)
            ],
          )),
    );
  }
}
