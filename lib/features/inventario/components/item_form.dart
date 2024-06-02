import 'package:ferret_erp/features/inventario/inventario_controller.dart';
import 'package:flutter/material.dart';
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

  final Map<String, TextEditingController> itemFormController = {
    'nombre': TextEditingController(),
    'cantidad': TextEditingController(),
    'foto': TextEditingController()
  };
  Future<void> _selectImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      itemFormController['foto']!.text = image.path;
    }
  }

  Map<String, dynamic> getFormData() {
    final res = <String, dynamic>{};
    for (MapEntry e in itemFormController.entries) {
      res.putIfAbsent(e.key,
          () => e.value?.text.isNotEmpty ? e.value.text : widget.idItem[e.key]);
    }
    return res;
  }

  void _populateFormFields({required Map<String, dynamic> item}) {
    for (MapEntry e in itemFormController.entries) {
      itemFormController[e.key]!.text = item[e.key].toString();
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
                            child: Stack(
                              alignment: AlignmentDirectional.bottomEnd,
                              children: [
                                item['foto'] != null
                                    ? Image.network(item['foto'])
                                    : Image.asset('assets/images/no-image.png'),
                                IconButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.amberAccent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      )),
                                  icon: const Icon(Icons.edit,
                                      color: Colors.grey),
                                  onPressed: () async {
                                    await _selectImage();
                                  },
                                ),
                              ],
                            ),
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

                          /*Modular.to.path.toString().contains('editarEmpleado')
                              ? //enseñar botones con logica para actualizar o eliminar empleado
                              EditDeleteEmpleadoButtonBar(
                                  idTrabajador: widget.empleado['id'],
                                  formularioEstado: _formularioEstado,
                                  refreshNotifier: widget.refreshNotifier,
                                  trabajadorFormController:
                                      itemFormController,
                                  empleado: widget.empleado)
                              : NewEmpleadoButton(
                                  formularioEstado: _formularioEstado,
                                  refreshNotifier: widget.refreshNotifier,
                                  trabajadorFormController:
                                      itemFormController,
                                  empleado: widget.empleado)
                        */
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
      case false:
        return const Placeholder();
    }
  }
}
