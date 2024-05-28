import 'package:ferret_erp/features/empleados/components/empleado_work_table.dart';
import 'package:ferret_erp/features/empleados/empleados_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class EmpleadosModule extends Module {
  @override
  void routes(r) {
    r.child('/', child: (context) => const EmpleadosPage(), children: [
      ChildRoute('/tablaTrabajos/:idTrabajador',
          child: (_) =>
              EmpleadoWorkTable(trabajador: r.args.params['idTrabajador'])),
    ]);
  }
}
