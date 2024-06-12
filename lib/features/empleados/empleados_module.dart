import 'package:ferret_erp/features/empleados/empleados_page.dart';
import 'package:ferret_erp/features/empleados/pages/agregar_empleado_page.dart';
import 'package:ferret_erp/features/empleados/pages/agregar_trabajo_page.dart';
import 'package:ferret_erp/features/empleados/pages/editar_empleado_page.dart';
import 'package:ferret_erp/features/empleados/pages/historial_trabajo_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class EmpleadosModule extends Module {
  final List<ChildRoute> _moduleRoutes = [
    ChildRoute('/agregarTrabajo/',
        child: (context) => const AgregarTrabajoPage()),
    ChildRoute('/historialTrabajo/',
        child: (context) => const HistorialTrabajo()),
    ChildRoute('/editarEmpleado/', child: (context) => const EditarEmpleado()),
    ChildRoute('/agregarEmpleado/',
        child: (context) => const AgregarEmpleadoPage()),
  ];

  List<ChildRoute> get moduleRoutes => _moduleRoutes;

  @override
  void routes(r) {
    print('ROUTES EMPLEADOS');
    r.child('/',
        child: (context) => const EmpleadosPage(), children: _moduleRoutes);
  }
}
