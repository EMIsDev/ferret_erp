import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inventario_module/models/item_model.dart';

import '../pages/editar_item_page.dart';

String newFoto = '';

class EditDeleteItemButtonBar extends StatelessWidget {
  final GlobalKey<FormState> formularioEstado;
  final Map<String, dynamic> itemFormController;
  final Function() refreshNotifier;
  final Item item;
  const EditDeleteItemButtonBar({
    super.key,
    required this.item,
    required this.refreshNotifier,
    required this.formularioEstado,
    required this.itemFormController,
  });
  Map<String, dynamic> getFormData() {
    final res = <String, dynamic>{};

    for (MapEntry e in itemFormController.entries) {
      Map<String, dynamic> itemMap = item.toJson();
      if (e.value is TextEditingController) {
        res.putIfAbsent(e.key,
            () => e.value?.text.isNotEmpty ? e.value.text : itemMap[e.key]);
      } else {
        newFoto = e.value.toString(); // guardamos el campo string de foto_nueva
        //  res.putIfAbsent(e.key, () => e.value);
      }
    }
    res.putIfAbsent('id', () => item.id);

    return res;
  }

  Future<bool> _updateItem({required Item item}) async {
    return await itemsController.updateItem(
        updatedItem: item, newFoto: newFoto);
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
            Item updatedItem = Item.fromJson(formData);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Procesando')),
            );
            _updateItem(item: updatedItem).then((value) {
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
                            GoRouter.of(context).pop();
                          },
                          child: const Text('No')),
                      ElevatedButton(
                        onPressed: () {
                          GoRouter.of(context).pop();
                          _deleteItem(
                                  idItem: item.id,
                                  fotoUrl: itemFormController['foto'].text)
                              .then((value) {
                            if (value) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Eliminado'),
                                  backgroundColor: Colors.green,
                                  onVisible: () {
                                    //GoRouter.of(context).pop(); // cambiar toPushNamed para poder hacer pop correctamente, sino se queda todo en negro por el contexto
                                    GoRouter.of(context)
                                        .go('/inventario/listaItems/');
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
