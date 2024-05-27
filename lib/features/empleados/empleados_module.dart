import 'package:ferret_erp/features/empleados/empleados_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class EmpleadosModule extends Module {
 @override
  void routes(r) {
    r.child('/', child: (context) => const EmpleadosPage());
  }
}