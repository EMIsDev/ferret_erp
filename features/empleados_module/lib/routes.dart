import 'package:empleados_module/pages/agregar_trabajo_page.dart';
import 'package:empleados_module/pages/historial_trabajo_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'pages/agregar_empleado_page.dart';
import 'pages/editar_empleado_page.dart';

final Map<String, dynamic> routes = {
  'nombre_modulo': 'Empleados',
  'icon': const Icon(Icons.people),
  'routes': [
    {
      'icon': const Icon(Icons.handyman),
      'route': GoRoute(
          name: 'Agregar Trabajo',
          path: '/agregarTrabajo',
          builder: (context, state) => const AgregarTrabajoPage())
    },
    {
      'icon': const Icon(Icons.history),
      'route': GoRoute(
          name: 'Historial Trabajo',
          path: '/historialTrabajo',
          builder: (context, state) => const HistorialTrabajo())
    },
    {
      'icon': const Icon(Icons.edit),
      'route': GoRoute(
          name: 'Editar Empleado',
          path: '/editarEmpleado',
          builder: (context, state) => const EditarEmpleado())
    },
    {
      'icon': const Icon(Icons.watch),
      'route': GoRoute(
          name: 'Agregar Empleado',
          path: '/agregarEmpleado',
          builder: (context, state) => const AgregarEmpleadoPage())
    },
  ]
};
