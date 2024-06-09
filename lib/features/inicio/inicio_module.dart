import 'package:ferret_erp/features/inicio/inicio_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class InicioModule extends Module {
  @override
  void routes(r) {
    r.child('/', child: (context) => const InicioPage());
  }
}
