import 'package:ferret_erp/features/empleados/pages/agregar_trabajo_page.dart';
import 'package:go_router/go_router.dart';

import 'pages/agregar_empleado_page.dart';
import 'pages/editar_empleado_page.dart';
import 'pages/historial_trabajo_page.dart';

final List<GoRoute> routes = [
  GoRoute(
      path: '/agregarTrabajo/',
      builder: (context, state) => const AgregarTrabajoPage()),
  GoRoute(
      path: '/historialTrabajo/',
      builder: (context, state) => const HistorialTrabajo()),
  GoRoute(
      path: '/editarEmpleado/',
      builder: (context, state) => const EditarEmpleado()),
  GoRoute(
      path: '/agregarEmpleado/',
      builder: (context, state) => const AgregarEmpleadoPage()),
];
