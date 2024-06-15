import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inventario_module/pages/agregar_item_page.dart';
import 'package:inventario_module/pages/editar_item_page.dart';
import 'package:inventario_module/pages/lista_items_page.dart';

final Map<String, dynamic> routes = {
  'nombre_modulo': 'Inventario',
  'icon': const Icon(Icons.inventory),
  'routes': [
    {
      'icon': const Icon(Icons.list),
      'route': GoRoute(
          name: 'Lista Items',
          path: '/listaItems',
          builder: (context, state) => const ListaItemsPage())
    },
    {
      'icon': const Icon(Icons.add),
      'route': GoRoute(
          name: 'Agregar Item',
          path: '/agregarItem',
          builder: (context, state) => const AgregarItemPage())
    },
    {
      //  'icon': const Icon(Icons.edit),
      'sidebarView': false,
      'route': GoRoute(
          name: 'Editar Item',
          path: '/editarItem/:idItem',
          builder: (context, state) =>
              EditarItem(idItem: state.pathParameters['idItem'] ?? ''))
    },
  ]
};
