import 'package:ferret_erp/features/empleados/empleados_controller.dart';
import 'package:flutter/material.dart';

class EmpleadoForm extends StatefulWidget {
  final String trabajador;

  const EmpleadoForm({super.key, required this.trabajador});

  @override
  State<EmpleadoForm> createState() => _EmpleadoFormState();
}

class _EmpleadoFormState extends State<EmpleadoForm> {
  final empleadosController = EmpleadosController();
  final GlobalKey<FormState> _formularioEstado = GlobalKey<FormState>();
  Map<String, dynamic> empleado = {};
  final Map<String, TextEditingController> clientFormController = {
    'nombre': TextEditingController(),
    'apellido': TextEditingController(),
    'telefono': TextEditingController()
  };

  Map<String, dynamic> getFormData() {
    final res = <String, dynamic>{};

    for (MapEntry e in clientFormController.entries) {
      res.putIfAbsent(e.key,
          () => e.value?.text.isNotEmpty ? e.value.text : empleado[e.key]);
    }
    res['idTrabajador'] = widget.trabajador;
    return res;
  }

  Future<int> _updateEmpleado(formData) async {
    return await Future.delayed(const Duration(seconds: 2), () => 1);
  }

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
                empleado = snapshot.data as Map<String, dynamic>;
                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Form(
                      key: _formularioEstado,
                      child: Column(
                        children: [
                          Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.grey)),
                              child: TextFormField(
                                controller: clientFormController['nombre'],
                                validator: (value) {
                                  if (value!.isNotEmpty) {
                                    return null; // todo ok
                                  } else {
                                    return 'Error en validacion'; // mal
                                  }
                                },
                                decoration: InputDecoration(
                                  hintText: '${empleado['nombre']}',
                                  border: InputBorder.none,
                                  labelText: 'Nombre',
                                ),
                              )),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.grey)),
                              child: TextFormField(
                                controller: clientFormController['apellido'],
                                validator: (value) {
                                  if (value!.isNotEmpty) {
                                    return null; // todo ok
                                  } else {
                                    // return 'Error en validacion'; // mal
                                    return null;
                                  }
                                },
                                decoration: InputDecoration(
                                  hintText: '${empleado['apellido']}',
                                  border: InputBorder.none,
                                  labelText: 'apellido',
                                ),
                              )),
                          Expanded(
                            //con esto hacemos la separación del boton de enviar
                            child: Container(),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formularioEstado.currentState!
                                    .validate()) {
                                  _formularioEstado.currentState!.save();
                                  final formData = getFormData();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Procesando')),
                                  );
                                  _updateEmpleado(formData).then((value) {
                                    if (!value.isNaN) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text('Actualizado'),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                      Navigator.pop(context);
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text('Error'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  });
                                }
                              },
                              child: const Text('Actualizar'),
                            ),
                          )
                        ],
                      )),
                );
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
