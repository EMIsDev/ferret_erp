import 'package:ferret_erp/features/inventario/pages/editar_item_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class EditDeleteItemButtonBar extends StatelessWidget {
  final String idItem;
  final GlobalKey<FormState> formularioEstado;
  final Map<String, dynamic> itemFormController;
  final Function() refreshNotifier;

  const EditDeleteItemButtonBar({
    super.key,
    required this.idItem,
    required this.refreshNotifier,
    required this.formularioEstado,
    required this.itemFormController,
  });
  Map<String, dynamic> getFormData() {
    final res = <String, dynamic>{};

    for (MapEntry e in itemFormController.entries) {
      if (e.value is TextEditingController) {
        res.putIfAbsent(
            e.key, () => e.value?.text.isNotEmpty ? e.value.text : '');
      } else {
        res.putIfAbsent(
            e.key, () => e.value); // guardamos el campo string de foto_nueva
      }
    }
    return res;
  }

  Future<bool> _updateItem(formData) async {
    return await itemsController.updateItem(
      idItem: idItem,
      updatedData: formData,
    );
  }

  Future<bool> _deleteItem(
      {required String idItem, required String fotoUrl}) async {
    return await itemsController.deleteItem(idItem, fotoUrl);
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
                      debugPrint('se ha actualizado el item');

                      refreshNotifier(); //actualizar pagina item

                      //debugPrint(Modular.to.navigateHistory.last.uri.toString());
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
                    content: const Text('Seguro que quieres eliminar al item?'),
                    actions: [
                      ElevatedButton(
                          onPressed: () {
                            Modular.to.pop();
                          },
                          child: const Text('No')),
                      ElevatedButton(
                        onPressed: () {
                          Modular.to.pop();
                          debugPrint(idItem);
                          _deleteItem(
                                  idItem: idItem,
                                  fotoUrl: itemFormController['foto'].text)
                              .then((value) {
                            if (value) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Eliminado'),
                                  backgroundColor: Colors.green,
                                  onVisible: () {
                                    //Modular.to.pop(); // cambiar toPushNamed para poder hacer pop correctamente, sino se queda todo en negro por el contexto
                                    Modular.to
                                        .navigate('/inventario/listaItems/');
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
