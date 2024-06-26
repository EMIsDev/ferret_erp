import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inventario_module/models/item_model.dart';
import 'package:inventario_module/pages/editar_item_page.dart';

class NewItemButton extends StatelessWidget {
  final GlobalKey<FormState> formularioEstado;
  final Map<String, dynamic> itemFormController;
  final Function() refreshNotifier;

  const NewItemButton({
    super.key,
    required this.formularioEstado,
    required this.refreshNotifier,
    required this.itemFormController,
  });
  Map<String, dynamic> getFormData() {
    final res = <String, dynamic>{};

    for (MapEntry e in itemFormController.entries) {
      if (e.value is TextEditingController) {
        res.putIfAbsent(
            e.key, () => e.value?.text.isNotEmpty ? e.value.text : '');
      }
    }
    return res;
  }

  Future<String> _agregarItem({required Item item}) async {
    return await itemsController.addItem(newItem: item);
  }

  @override
  Widget build(BuildContext context) {
    return ButtonBar(alignment: MainAxisAlignment.center, children: [
      ElevatedButton(
        onPressed: () {
          if (formularioEstado.currentState!.validate()) {
            formularioEstado.currentState!.save();
            final formData = getFormData();
            Item newItem = Item.fromJson(formData);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Procesando')),
            );

            _agregarItem(item: newItem).then((idItemBd) {
              if (idItemBd.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Agregado correctamente'),
                    backgroundColor: Colors.green,
                    onVisible: () {
                      GoRouter.of(context).go('/editarItem/$idItemBd');

                      //Navigator.of(context).pushReplacementNamed(
                      //  '/empleados/',
                      //);
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
        child: const Text('CREAR'),
      )
    ]);
  }
}
