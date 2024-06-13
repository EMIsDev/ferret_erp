import 'package:flutter/material.dart';

import '../components/item_form.dart';

class AgregarItemPage extends StatefulWidget {
  const AgregarItemPage({super.key});

  @override
  State<AgregarItemPage> createState() => _AgregarItemPageState();
}

class _AgregarItemPageState extends State<AgregarItemPage> {
  @override
  Widget build(BuildContext context) {
    return const Column(children: [ItemForm()]);
  }

  void refreshDropDown({String idTrabajador = ''}) {
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }
}
