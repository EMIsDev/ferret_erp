import 'package:ferret_erp/features/empleados/components/empleado_work_table.dart';
import 'package:ferret_erp/features/empleados/empleados_page.dart';
import 'package:ferret_erp/features/empleados/pages/agregar_trabajo_page.dart';
import 'package:ferret_erp/features/empleados/pages/editar_empleado_page.dart';
import 'package:ferret_erp/features/empleados/pages/historial_trabajo_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class EmpleadosModule extends Module {
  final List<ChildRoute> _moduleRoutes = [
    ChildRoute('/tablaTrabajos/:idTrabajador',
        child: (context) => EmpleadoWorkTable(
            trabajadorId: Modular.args.params['idTrabajador'])),
    ChildRoute('/info/:idTrabajador',
        child: (context) => const EditarEmpleado()),
    ChildRoute('/agregarTrabajo/',
        child: (context) => const AgregarTrabajoPage()),
    ChildRoute('/historialTrabajo/',
        child: (context) => const HistorialTrabajo()),
    ChildRoute('/editarEmpleado/', child: (context) => const EditarEmpleado()),
  ];

  List<ChildRoute> get moduleRoutes => _moduleRoutes;
  @override
  void routes(r) {
    r.child('/',
        child: (context) => const EmpleadosPage(), children: _moduleRoutes);
  }
}
