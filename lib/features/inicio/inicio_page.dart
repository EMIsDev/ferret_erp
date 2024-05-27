import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class InicioPage extends StatefulWidget {
  const InicioPage({super.key});

  @override
  State<InicioPage> createState() => _InicioPageState();
}

class _InicioPageState extends State<InicioPage> {
  @override
  Widget build(BuildContext context) {
    //imprimirDatosBD();
    return Row(
      children: [
        ElevatedButton(
          onPressed: () {
            imprimirDatosBD();
          },
          child: const Text('Imprimir datos'),
        ),
        ElevatedButton(
          onPressed: () {
            imprimirDatosBD();
          },
          child: const Text('Imprimir datos'),
        ),
      ],
    );
  }

  Future<void> imprimirDatosBD() async {
    var a = await FirebaseFirestore.instance.collection('empleados').get();
    for (var element in a.docs) {
      print(element.data());
    }
  }
}
