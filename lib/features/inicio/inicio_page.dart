import 'package:flutter/material.dart';

class InicioPage extends StatelessWidget {
  const InicioPage({super.key});

  @override
  Widget build(BuildContext context) {

    return const Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text('Inicio'),
        Icon(Icons.people),
      ],
    );
  }
}