import 'package:empleados_module/pages/agregar_trabajo_page.dart';
import 'package:go_router/go_router.dart';

import 'pages/agregar_empleado_page.dart';
import 'pages/editar_empleado_page.dart';
import 'pages/historial_trabajo_page.dart';

final List<GoRoute> routes = [
  GoRoute(
      name: 'Agregar Trabajo',
      path: '/agregarTrabajo',
      builder: (context, state) => const AgregarTrabajoPage()),
  GoRoute(
      name: 'Historial Trabajo',
      path: '/historialTrabajo',
      builder: (context, state) => const HistorialTrabajo()),
  GoRoute(
      name: 'Editar Empleado',
      path: '/editarEmpleado',
      builder: (context, state) => const EditarEmpleado()),
  GoRoute(
      name: 'Agregar Empleado',
      path: '/agregarEmpleado',
      builder: (context, state) => const AgregarEmpleadoPage()),
];
