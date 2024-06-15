import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inicio_module/inicio_page.dart';

final Map<String, dynamic> routes = {
  'nombre_modulo': 'Inicio',
  'routes': [
    {
      'icon': const Icon(Icons.home),
      'route': GoRoute(
          name: 'Inicio',
          path: '/inicio',
          builder: (context, state) => const InicioPage())
    },
  ],
};
