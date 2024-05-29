import 'package:ferret_erp/features/empleados/components/empleado_info_card.dart';
import 'package:ferret_erp/features/empleados/components/empleado_work_table.dart';
import 'package:ferret_erp/features/empleados/empleados_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class EmpleadosModule extends Module {
  final List<ChildRoute> _moduleRoutes = [
    ChildRoute('/tablaTrabajos/:idTrabajador',
        child: (context) =>
            EmpleadoWorkTable(trabajador: Modular.args.params['idTrabajador'])),
    ChildRoute('/info/:idTrabajador',
        child: (context) =>
            EmpleadoInfoCard(trabajador: Modular.args.params['idTrabajador'])),
  ];

  List<ChildRoute> get moduleRoutes => _moduleRoutes;
  @override
  void routes(r) {
    r.child('/',
        child: (context) => const EmpleadosPage(), children: _moduleRoutes);
  }
}
