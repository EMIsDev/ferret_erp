import 'dart:io';

import 'package:ferret_erp/features/inventario/components/edit_delete_item_buttons.dart';
import 'package:ferret_erp/features/inventario/inventario_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:image_picker/image_picker.dart';

class ItemForm extends StatefulWidget {
  final String idItem;

  const ItemForm({
    super.key,
    this.idItem = '',
  });

  @override
  State<ItemForm> createState() => _ItemFormState();
}

class _ItemFormState extends State<ItemForm> {
  final itemController = ItemsController();
  final GlobalKey<FormState> _formularioEstado = GlobalKey<FormState>();
  String newSelectedImage = '';

  final ValueNotifier<bool> _notifier = ValueNotifier(false);
  final Map<String, dynamic> itemFormController = {
    'nombre': TextEditingController(),
    'cantidad': TextEditingController(),
    'foto': TextEditingController(),
    'foto_nueva': '',
  };
  Future<void> _selectImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      itemFormController['foto_nueva'] = image.path;
      _notifier.value =
          !_notifier.value; //notificar para recargar solo widget de foto
    }
  }

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

  void _populateFormFields({required Map<String, dynamic> item}) {
    for (MapEntry e in itemFormController.entries) {
      if (e.value is TextEditingController) {
        itemFormController[e.key]!.text = item[e.key].toString();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.idItem.isNotEmpty) {
      case true:
        return FutureBuilder(
            future: itemController.getItemById(itemId: widget.idItem),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                final Map<String, dynamic> item = snapshot.data!;
                _populateFormFields(item: item);
                return Flexible(
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formularioEstado,
                      child: Column(
                        children: [
                          ValueListenableBuilder(
                            valueListenable: _notifier,
                            builder: (context, value, child) {
                              return Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.grey)),
                                child: Stack(
                                  alignment: AlignmentDirectional.bottomEnd,
                                  children: [
                                    itemFormController['foto_nueva'].isNotEmpty
                                        ? Image.file(File(
                                            itemFormController['foto_nueva']))
                                        : item['foto'] != null
                                            ? Image.network(item['foto'])
                                            : Image.asset(
                                                'assets/images/no-image.png'),
                                    IconButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.amberAccent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          )),
                                      icon: const Icon(Icons.edit,
                                          color: Colors.grey),
                                      onPressed: () async {
                                        await _selectImage();
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
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
                                controller: itemFormController['nombre'],
                                validator: (value) {
                                  if (value!.isNotEmpty) {
                                    return null; // todo ok
                                  } else {
                                    return 'Error en validacion'; // mal
                                  }
                                },
                                decoration: InputDecoration(
                                  hintText: item['nombre'] ?? '',
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
                                controller: itemFormController['cantidad'],
                                validator: (value) {
                                  if (value!.isNotEmpty) {
                                    return null; // todo ok
                                  } else {
                                    // return 'Error en validacion'; // mal
                                    return null;
                                  }
                                },
                                decoration: InputDecoration(
                                  hintText: item['cantidad'].toString(),
                                  border: InputBorder.none,
                                  labelText: 'cantidad',
                                ),
                              )),
                          const SizedBox(
                            height: 10,
                          ),
                          Modular.to.path.toString().contains('editarItem')
                              ? //enseñar botones con logica para actualizar o eliminar empleado
                              EditDeleteItemButtonBar(
                                  idItem: widget.idItem,
                                  formularioEstado: _formularioEstado,
                                  itemFormController: itemFormController,
                                  refreshNotifier: refreshNotifier,
                                )
                              : const Placeholder() /*NewEmpleadoButton(
                                                formularioEstado: _formularioEstado,
                                                refreshNotifier: widget.refreshNotifier,
                                                trabajadorFormController:
                                                    itemFormController,
                                                empleado: widget.empleado)*/
                        ],
                      ),
                    ),
                  ),
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
      case false:
        return const Placeholder();
    }
  }

  void refreshNotifier() {
    setState(() {});
  }
}
