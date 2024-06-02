import 'package:ferret_erp/features/inventario/components/item_form.dart';
import 'package:ferret_erp/features/inventario/inventario_controller.dart';
import 'package:flutter/material.dart';

class EditarItem extends StatefulWidget {
  final String idItem;
  const EditarItem({super.key, required this.idItem});

  @override
  State<EditarItem> createState() => _EditarItemState();
}

Map<String, dynamic> item = {};
String selectedTrabajador = "";
final itemsController = ItemsController();
ValueNotifier<bool> _notifier = ValueNotifier(false);

class _EditarItemState extends State<EditarItem> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder(
          future: itemsController.getItemById(itemId: widget.idItem),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              item = snapshot.data!;

              return ItemForm(
                idItem: widget.idItem,
              );
            } else {
              return SizedBox(
                height: MediaQuery.of(context).size.height / 1.3,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
        ),
      ],
    );
  }

  void refreshNotifier(dynamic idTrabajador) {
    selectedTrabajador = idTrabajador['id'];
    _notifier.value = !_notifier.value;
  }

  void refreshDropDown({String idTrabajador = ''}) {
    setState(() {
      selectedTrabajador = idTrabajador;
    });
  }

  @override
  void dispose() {
    selectedTrabajador = ""; //reset selectedTrabajador
    super.dispose();
  }
}
