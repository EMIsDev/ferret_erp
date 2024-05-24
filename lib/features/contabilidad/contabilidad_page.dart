import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ContabilidadPage extends StatelessWidget {
  const ContabilidadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contabilidad Page')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Modular.to.navigate('/second'),
          child: const Text('Navigate to Second Page'),
        ),
      ),
    );
  }
}