import 'package:ferret_erp/features/inventario/pages/editar_item_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class EditDeleteItemButtonBar extends StatelessWidget {
  final String idItem;
  final GlobalKey<FormState> formularioEstado;
  final Map<String, TextEditingController> itemFormController;

  const EditDeleteItemButtonBar({
    super.key,
    required this.idItem,
    required this.formularioEstado,
    required this.itemFormController,
  });
  Map<String, dynamic> getFormData() {
    final res = <String, dynamic>{};

    for (MapEntry e in itemFormController.entries) {
      res.putIfAbsent(
          e.key, () => e.value?.text.isNotEmpty ? e.value.text : '');
    }
    print(res);
    return res;
  }

  Future<bool> _updateItem(formData) async {
    return await itemsController.updateItem(
        idItem: idItem, updatedData: formData);
  }

  Future<bool> _deleteEmpleado(idTrabajado) async {
    return await Future.delayed(const Duration(seconds: 1), () => true);
  }

  @override
  Widget build(BuildContext context) {
    return ButtonBar(alignment: MainAxisAlignment.center, children: [
      ElevatedButton(
        onPressed: () {
          if (formularioEstado.currentState!.validate()) {
            formularioEstado.currentState!.save();
            final formData = getFormData();

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Procesando')),
            );

            _updateItem(formData).then((value) {
              if (value) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Actualizado'),
                    backgroundColor: Colors.green,
                    onVisible: () {
                      /*  Modular.to.navigate(
                          Modular.to.navigateHistory.last.uri.toString());*/
                    },
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
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
      ElevatedButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (_) => AlertDialog(
                    title: const Text('ATENCIÓN!'),
                    content: const Text(
                        'Seguro que quieres eliminar al trabajador?'),
                    actions: [
                      ElevatedButton(
                          onPressed: () {
                            print(Modular.to.navigateHistory);
                          },
                          child: const Text('No')),
                      ElevatedButton(
                        onPressed: () {
                          Modular.to.pop();
                          _deleteEmpleado(idItem).then((value) {
                            if (value) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Eliminado'),
                                  backgroundColor: Colors.green,
                                  onVisible: () {
                                    //  refreshNotifier();
                                  },
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Error'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          });
                        },
                        child: const Text('Si'),
                      ),
                    ],
                  ),
              barrierDismissible: true);
        },
        child: const Text('Eliminar'),
      ),
    ]);
  }
}
