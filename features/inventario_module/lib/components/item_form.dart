import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inventario_module/components/edit_delete_item_buttons.dart';
import 'package:inventario_module/components/new_item_button.dart';
import 'package:inventario_module/models/item_model.dart';

import '../controllers/inventario_controller.dart';

class ItemForm extends StatefulWidget {
  final Item item;

  ItemForm({
    super.key,
    Item? item,
  }) : item = item ?? Item.empty();

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
    if (widget.item.id.isEmpty) {
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
      if (widget.item.id.isEmpty) {
        //caso de formulario nuevo, la foto siempre se pondra en el campo foto
        itemFormController['foto'].text = image.path;
      }

      itemFormController['foto_nueva'] = image.path;

      _notifier.value =
          !_notifier.value; //notificar para recargar solo widget de foto
    }
  }

  void _populateFormFields({required Item item}) {
    Map<String, dynamic> itemMap = item.toJson();
    for (MapEntry e in itemFormController.entries) {
      if (e.value is TextEditingController) {
        itemFormController[e.key]!.text = itemMap[e.key].toString();
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
                            ? Image.file(
                                File(itemFormController['foto_nueva']),
                                width: MediaQuery.of(context).size.width * 0.5,
                                height:
                                    MediaQuery.of(context).size.height * 0.5,
                              )
                            : widget.item.foto.isNotEmpty
                                ? Image.network(
                                    widget.item.foto,
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    height: MediaQuery.of(context).size.height *
                                        0.5,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image(
                                        image: const AssetImage(
                                            'assets/images/no-image.webp'),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.5,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.5,
                                      );
                                    },
                                  )
                                : Image(
                                    image: const AssetImage(
                                        'assets/images/no-image.webp'),
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    height: MediaQuery.of(context).size.height *
                                        0.5,
                                  ),
                        IconButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amberAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              )),
                          icon: Icon(
                              widget.item.foto.isNotEmpty
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
                      if (value!.isEmpty) {
                        return 'Error campo vacío';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: widget.item.nombre,
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
                      if (value!.isEmpty) {
                        return 'Error campo vacío';
                      }
                      if (int.tryParse(value) == null) {
                        if (double.tryParse(value) == null) {
                          return 'Error campo tiene que ser un número';
                        }
                      }
                      if (double.tryParse(value)! < 0) {
                        return 'Error campo tiene que ser un número mayor a 0';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: widget.item.cantidad.toString(),
                      border: InputBorder.none,
                      labelText: 'cantidad',
                    ),
                  )),
              const SizedBox(
                height: 10,
              ),
              GoRouter.of(context)
                      .routeInformationProvider
                      .value
                      .uri
                      .toString()
                      .contains('editarItem')
                  ? //enseñar botones con logica para actualizar o eliminar empleado
                  EditDeleteItemButtonBar(
                      item: widget.item,
                      formularioEstado: _formularioEstado,
                      itemFormController: itemFormController,
                      refreshNotifier: refreshNotifier,
                    )
                  : NewItemButton(
                      formularioEstado: _formularioEstado,
                      refreshNotifier: refreshNotifier,
                      itemFormController: itemFormController,
                      item: widget.item.toJson())
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
