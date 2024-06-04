import 'dart:io';

import 'package:ferret_erp/features/inventario/components/edit_delete_item_buttons.dart';
import 'package:ferret_erp/features/inventario/components/new_item_button.dart';
import 'package:ferret_erp/features/inventario/inventario_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:image_picker/image_picker.dart';

class ItemForm extends StatefulWidget {
  final Map<String, dynamic> item;
  final String idItem;

  const ItemForm({
    super.key,
    this.idItem = '',
    this.item = const {},
  });

  @override
  State<ItemForm> createState() => _ItemFormState();
}

class _ItemFormState extends State<ItemForm> {
  final itemController = ItemsController();
  final GlobalKey<FormState> _formularioEstado = GlobalKey<FormState>();

  final ValueNotifier<bool> _notifier = ValueNotifier(false);
  final Map<String, dynamic> itemFormController = {
    'nombre': TextEditingController(),
    'cantidad': TextEditingController(),
    'foto': TextEditingController(),
    'foto_nueva': '',
  };

  @override
  void initState() {
    super.initState();
    if (widget.item.isEmpty) {
      // asegurar que el formulario esta limpio para agregar un nuevo item
      _clearFormFields();
    } else {
      _populateFormFields(item: widget.item);
    }
  }

  Future<void> _selectImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      if (widget.item.isEmpty) {
        //caso de formulario nuevo, la foto siempre se pondra en el campo foto
        itemFormController['foto'].text = image.path;
      }

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

  void _clearFormFields() {
    for (MapEntry e in itemFormController.entries) {
      if (e.value is TextEditingController) {
        e.value.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey)),
                    child: Stack(
                      alignment: AlignmentDirectional.bottomEnd,
                      children: [
                        itemFormController['foto_nueva'].isNotEmpty
                            ? Image.file(File(itemFormController['foto_nueva']))
                            : widget.item['foto'] != null
                                ? Image.network(widget.item['foto'])
                                : Image.asset('assets/images/no-image.webp'),
                        IconButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amberAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              )),
                          icon: Icon(
                              widget.item['foto'] != null
                                  ? Icons.edit
                                  : Icons.add,
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
                  padding: const EdgeInsets.symmetric(horizontal: 10),
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
                      hintText: widget.item['nombre'] ?? '',
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
                      hintText: widget.item['cantidad']?.toString() ?? '',
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
                  : NewItemButton(
                      formularioEstado: _formularioEstado,
                      refreshNotifier: refreshNotifier,
                      itemFormController: itemFormController,
                      item: widget.item)
            ],
          ),
        ),
      ),
    );
  }

  void refreshNotifier() {
    setState(() {});
  }

  @override
  void dispose() {
    _notifier.dispose();
    itemFormController.forEach((key, value) {
      if (value is TextEditingController) {
        value.dispose();
      }
    });
    super.dispose();
  }
}
