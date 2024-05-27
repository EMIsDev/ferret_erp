import 'package:ferret_erp/features/contabilidad/contabilidad_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ContabilidadModule extends Module {
 @override
  void routes(r) {
    r.child('/', child: (context) => const ContabilidadPage());
  }
}