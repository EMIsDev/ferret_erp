import 'package:flutter/material.dart';

import '../components/item_form.dart';
import '../controllers/inventario_controller.dart';
import '../models/item_model.dart';

class EditarItem extends StatefulWidget {
  final String idItem;
  const EditarItem({super.key, required this.idItem});

  @override
  State<EditarItem> createState() => _EditarItemState();
}

Map<String, dynamic> item = {};
String selectedItem = "";
final itemsController = ItemsController();

class _EditarItemState extends State<EditarItem> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder(
          future: itemsController.getItemById(itemId: widget.idItem),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              Item item = snapshot.data!;
              return ItemForm(
                item: item,
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

  void refreshDropDown({String idTrabajador = ''}) {
    setState(() {
      selectedItem = idTrabajador;
    });
  }

  @override
  void dispose() {
    selectedItem = "";

    super.dispose();
  }
}
